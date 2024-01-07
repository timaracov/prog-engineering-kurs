(import fastapi [Query])
(import fastapi.responses [JSONResponse])
(import sqlite3 [IntegrityError])

(import models [Document SortKey Author Department])
(import db *)

(defn prep-d [d] 
  (setv rd f"'{d}'")
  (cond 
    (= (. d isdecimal) True)
      (setv rd (int d)))
  rd)
;------------------------------------------------------------------------------;

;; DOCS
(defn add-docs [#^ Document doc]
  (setv resp 
        (JSONResponse (dict :message "ok") :status_code 201))
  (try
    (add-record doc "docs")
    (except [e IntegrityError]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)
  
(defn get_docs [(annotate sort-by SortKey) 
                (annotate sort-key-value str)
                [page (Query 0)] 
                [num (Query 25)]] 
  (setv tuple-docs 
    (get-data-by-key
      "docs" sort-by.value (prep-d sort-key-value) page num))
  (lfor d tuple-docs
    (Document.model_validate 
      (tuple-to-model d Document))))

(defn update_doc [#^ str doc_id 
                  #^ Document data] 
  (update-record data "docs" "doc_id" doc_id)
  (JSONResponse (dict :message "ok")))

(defn delete_doc [#^ str doc_id]
  (delete-record doc_id "doc_id" "docs")
  (JSONResponse (dict :message "ok")))
;------------------------------------------------------------------------------;


;; AUTHORS
(defn add-author [#^ Author author] 
  (setv resp 
        (JSONResponse (dict :message "ok") :status_code 201))
  (try
    (add-record author "author")
    (except [e IntegrityError]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)

(defn get-author [(annotate sort-by SortKey) 
                  (annotate sort-key-value str)
                  [page (Query 0)] 
                  [num (Query 25)]] 
  (setv tuple-docs 
    (get-data-by-key
      "author" sort-by.value (prep-d sort-key-value) page num))
  (lfor d tuple-docs
    (Author.model_validate 
      (tuple-to-model d Author))))

(defn update-author [#^ str author_id
                     #^ Author author] 
  (update-record author "author" "author_id" author_id)
  (JSONResponse (dict :message "ok")))
 
(defn delete-author [#^ str author_id]
  (delete-record author_id "author_id" "author")
  (JSONResponse (dict :message "ok")))
;------------------------------------------------------------------------------;


;; DEPARMENTS
(defn add-department [#^ Department dep]
  (setv resp 
        (JSONResponse (dict :message "ok") :status_code 201))
  (try
    (add-record dep "departments")
    (except [e IntegrityError]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)
(defn get-department [(annotate sort-by SortKey) 
                      (annotate sort-key-value str)
                      [page (Query 0)] 
                      [num (Query 25)]] 
  (setv tuple-docs 
    (get-data-by-key
      "departments" sort-by.value (prep-d sort-key-value) page num))
  (lfor d tuple-docs
    (Department.model_validate 
      (tuple-to-model d Department))))
 
(defn update-department [#^ str dep_id
                         #^ Department dep] 
  (update-record dep "departments" "department_id" dep_id)
  (JSONResponse (dict :message "ok")))

(defn delete-department [#^ str dep_id]
  (delete-record dep_id "department_id" "departments")
  (JSONResponse (dict :message "ok")))
;------------------------------------------------------------------------------;


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
;------------------------------------------------------------------------------;
