(import sqlite3 :as sql)
(import models [Document])
(import fakes [generate-fake-document])
(import pprint [pprint])

(defn get-con [] 
  (setv conn (sql.connect "src.db"))
  conn)

(defn get-cur []
  (setv con (get-con))
  (con.cursor))

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
  (print query)
  (cur.execute query)
  (setv tuple-data (cur.fetchall))
  (lfor td tuple-data 
        (dict 
          :doc_id (get td 0)
          :name (get td 1)
          :folder (get td 2)
          :version (get td 3)
          :author_id (get td 4))))

(defn insert-document [#^ Document doc]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query (+
    "insert into docs (doc_id, name, folder, version, author_id) values ("
      f"{doc.doc_id}, "
      f"'{doc.name}', "
      f"'{doc.folder}', "
      f"'{doc.version}', "
      f"{doc.author_id}"
    ")"))
  (cur.execute query)
  (con.commit))

(defn update-document [#^ Document doc]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query (+
    "update docs set "
    f"name = '{doc.name}', "
    f"folder = '{doc.folder}', "
    f"version = '{doc.version}', "
    f"author_id = {doc.author_id} "
    f"where doc_id = {doc.doc_id}"))
  (cur.execute query)
  (con.commit))

(defn delete-document [#^ int doc_id]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query f"delete from docs where doc_id = {doc_id}")
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
