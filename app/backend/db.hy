(import sqlite3 :as sql)
(import models [Document BaseModel])
(import fakes [generate-fake-document])
(import pprint [pprint])

(require hyrule [assoc])

(defn get-con [] 
  (setv conn (sql.connect "src.db"))
  conn)

(defn get-cur []
  (setv con (get-con))
  (con.cursor))

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
  (print query)
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
      "department_id integer,"
      "foreign key(department_id) references departments(department_id)"
    ")"))
  (cur.execute (+
    "create table if not exists docs("
      "doc_id integer unique primary key not null,"
      "name text not null unique,"
      "folder text not null,"
      "version text not null,"
      "author_id integer,"
      "foreign key(author_id) references authors(author_id)"
    ")")))

(defn fill-docs [] 
  (for [index (range 15)]
    (setv doc (generate-fake-document))
    ((. doc update) (dict :author_id 0 :doc_id index))
    (insert-document 
      ((. Document model_validate) doc))))

(defn prepare-db [] 
  (create-tables)
  (try
    (fill-docs)
    (except []
      (print "\033[32mINFO\033[m:     Data already exist"))))
