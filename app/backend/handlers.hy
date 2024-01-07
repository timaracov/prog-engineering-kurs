(import fastapi [Query])
(import fastapi.responses [JSONResponse])
(import sqlite3 [IntegrityError])

(import models [Document SortKey])
(import db *)

(defn prep-d [d] 
  (setv rd f"'{d}'")
  (cond 
    (= (. d isdecimal) True)
      (setv rd (int d)))
  rd)

;; DOCS
(defn add-docs [#^ Document doc]
  (setv resp 
        (JSONResponse (dict :message "ok") :status_code 201))
  (try
    (insert-document doc)
    (except [e IntegrityError]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)
  
(defn get_docs [(annotate sort-by SortKey) 
                (annotate sort-key-value str)
                [page (Query 0)] 
                [num (Query 25)]] 
  (setv dict-docs 
    (get-data-by-key
      "docs" sort-by.value (prep-d sort-key-value) page num))
  (print dict-docs)
  (lfor d dict-docs (Document.model_validate d)))

(defn update_doc [#^ str doc_id 
                  #^ Document data] 
  (update-document data)
  (JSONResponse (dict :message "ok")))

(defn delete_doc [#^ str doc_id]
  (delete-document doc_id)
  (JSONResponse (dict :message "ok")))

;; AUTHORS
(defn add-author [#^ dict doc] doc)
(defn get-author [(annotate sort_by SortKey) 
                [page (Query 0)] 
                [num (Query 25)]] 
  [page num sort_by.value])
(defn update-author [#^ str doc_id 
                  #^ dict data] 
  [doc_id data])
(defn delete-author [#^ str doc_id]
  doc_id)

;; DEPARMENTS
(defn add-department [#^ dict doc] doc)
(defn get-department [(annotate sort_by SortKey) 
                [page (Query 0)] 
                [num (Query 25)]] 
  [page num sort_by.value])
(defn update-department [#^ str doc_id 
                  #^ dict data] 
  [doc_id data])
(defn delete-department [#^ str doc_id]
  doc_id)

;; AUTH
(defn login-user [#^ str username 
                  #^ str password]
  [username password])
(defn login-admin [#^ str username 
                  #^ str password]
  [username password])
(defn get-user []
  (dict))
(defn get-admin []
  (dict))
(defn logout-user []
  (dict))
(defn logout-admin []
  (dict))
