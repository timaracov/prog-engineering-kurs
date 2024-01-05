(import sqlite3 :as sql)
(import models [Document])

(defn get-con [] 
  (setv conn (sql.connect "src.db"))
  conn)

(defn get-cur []
  (setv con (get-con))
  (con.cursor))

(defn get-data-by-key [#^ str table 
                       #^ str key
                       #^ str data-value]
  (setv con (get-con))
  (setv cur (con.cursor))
  (setv query f"select * from {table} where {key} = '{data-value}' group by {key}")
  (cur.execute query)
  (cur.fetchall))

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

(defn prepare []
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

; main
(prepare)
(insert-document 
  (Document 
    :doc_id 12
    :name "bob"
    :folder "/root"
    :version "0.0.0"
    :author_id 0))
(print (get-data-by-key "docs" "name" "bob"))
