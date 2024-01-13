(import os)
(import sqlite3 :as sql)
(import models [Document BaseModel])
(import fakes *)
(import pprint [pprint])

(require hyrule [assoc])

(defn get-con [] 
  (setv conn (sql.connect "src.db"))
  conn)

(defn get-cur []
  (setv con (get-con))
  (con.cursor))

(defn get-authors-joined [] 
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query (+
      "select author_id, "
             "fullname, "
             "education, "
             "university, "
             "departments.department_id, "
             "departments.name, "
             "departments.location, "
             "departments.head, "
             "departments.phone "
      "from author join departments on departments.department_id = author.department"))
  (cur.execute query)
  (setv tuple-data (cur.fetchall))
  (setv res [])
  (for [x tuple-data] 
    ((. res append) 
     (dict 
       :author_id (get x 0)
       :fullname (get x 1)
       :education (get x 2)
       :university (get x 3)
       :department_id (get x 4)
       :department_name (get x 5)
       :department_location (get x 6)
       :department_head (get x 7)
       :department_phone (get x 8))))
  res)

(defn get-docs-joined [] 
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query (+
      "select doc_id, "
             "docs.name as name, "
             "folder, "
             "version, "
             "fullname, "
             "education, "
             "university, "
             "departments.name as dep_name, "
             "location, "
             "head, "
             "author.author_id as author, "
             "phone "
      "from docs join author on author.author_id = docs.author "
      "join departments on departments.department_id = author.department"))
  (cur.execute query)
  (setv tuple-data (cur.fetchall))
  (setv res [])
  (for [x tuple-data] 
    ((. res append) 
     (dict 
       :doc_id (get x 0)
       :name (get x 1)
       :folder (get x 2)
       :version (get x 3)
       :fullname (get x 4)
       :education (get x 5)
       :univercity (get x 6)
       :dep_name (get x 7)
       :location (get x 8)
       :head (get x 9)
       :author (get x 10)
       :phone (get x 11))))
  res)

(defn get-data-part [#^ str table #^ int page #^ int num]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query f"select * from {table} limit {num} offset {page}")
  (cur.execute query)
  (setv tuple-data (cur.fetchall))
  tuple-data)

(defn get-data-by-key [#^ str table 
                       #^ str key
                       #^ str data-value
                       #^ int page
                       #^ int num]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query (+
    f"select * from {table} "
    f"where {key} = {data-value} "
    f"order by {key} "
    f"limit {num} "
    f"offset {page}"))
  (cur.execute query)
  (setv tuple-data (cur.fetchall))
  tuple-data)

(defn tuple-to-model [#^ tuple data
                      #^ BaseModel model]
  (setv res (dict))
  (setv kvs ((. (. model model_fields) items)))
  (setv enkvs (enumerate kvs))
  (for [en_pair enkvs]
    (setv n (get en_pair 0))
    (setv k (get (get en_pair 1) 0))
    (assoc res k (get data n)))
  res)

(defn add-record [#^ BaseModel mr
                  #^ str table] 
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv record-keys 
    (+ "("
       ((. ", " join) 
         (tuple 
           ((.  (. mr model_fields) keys))))
       ")"))
  (setv query (+
    f"insert into {table} {record-keys} values ("
    ((. ", " join)
      (lfor el 
            (tuple ((. ((. mr model_dump)) values)))
       (if (= (isinstance el int) True)
             (str el)
             f"'{el}'")))
    ")"))
  (cur.execute query)
  (con.commit))


(defn update-record [#^ BaseModel mr
                     #^ str table
                     #^ str record_key
                     #^ int record_id]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv rstr "")
  (setv kvs ((. ((. mr model_dump)) items)))
  (for [pair kvs]
    (setv v (get pair 1))
    (setv k (get pair 0))
    (setv rstr (+
        rstr
        f"{k} = "
        (if (= (isinstance v int) True)
            f"{v}, " f"'{v}', "))))
  (setv query (+
    f"update {table} set " 
    (cut rstr 0 -2)
    f" where {record_key} = {record_id}"))
  (cur.execute query)
  (con.commit))

(defn delete-record [#^ int record_id
                     #^ str record_key
                     #^ str table]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query f"delete from {table} where {record_key} = {record_id}")
  (cur.execute query)
  (con.commit))

(defn create-tables []
  (setv con (get-con))
  (setv cur (con.cursor))
  (cur.execute (+
    "create table if not exists users("
      "user_id integer unique primary key not null,"
      "username text unique not null,"
      "is_admin integer not null default 0 check(is_admin < 2 AND is_admin > -1),"
      "password text not null"
    ")"))
  (cur.execute (+
    "create table if not exists departments("
      "department_id integer unique primary key not null,"
      "name text not null,"
      "location text not null,"
      "head text not null,"
      "phone text not null"
    ")"))
  (cur.execute (+
    "create table if not exists author("
      "author_id integer unique primary key not null,"
      "fullname text not null,"
      "education text not null,"
      "university text not null,"
      "department integer,"
      "foreign key(department) references departments(department_id)"
    ")"))
  (cur.execute (+
    "create table if not exists docs("
      "doc_id integer unique primary key not null,"
      "name text not null unique,"
      "folder text not null,"
      "version text not null,"
      "author integer,"
      "foreign key(author) references authors(author_id)"
    ")")))

(defn fill-docs [] 
  (for [index (range 15)]
    (setv doc (generate-fake-document))
    ((. doc update) (dict :doc_id index))
    (setv doc-model ((. Document model_validate) doc))
    (add-record doc-model "docs")))

(defn fill-authors [] 
  (for [index (range 15)]
    (setv author (generate-fake-author))
    ((. author update) (dict :author_id index))
    (setv author-model ((. Author model_validate) author))
    (add-record author-model "author")))

(defn fill-departments [] 
  (for [index (range 15)]
    (setv dep (generate-fake-department))
    ((. dep update) (dict :department_id index))
    (setv dep-model ((. Department model_validate) dep))
    (add-record dep-model "departments")))

(defn fill-users [] 
  (for [index (range 15)]
    (setv u (generate-fake-user))
    ((. u update) (dict :user_id index))
    (setv u-model ((. User model_validate) u))
    (add-record u-model "users")))

(defn prepare-db [] 
  (cond (= (os.path.exists "src.db") False)
      (try
        (create-tables)
        (fill-departments)
        (fill-authors)
        (fill-docs)
        (fill-users)
        (print "\033[32mINFO\033[m:     Filled")
        (except [e Exception]
          (print f"\033[32mINFO\033[m:     Data already exist: {e}")))))
