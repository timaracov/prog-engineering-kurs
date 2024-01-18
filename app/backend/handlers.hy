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
    (setattr doc "doc_id" None)
    (add-record doc "docs")
    (except [e Exception]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)

(defn get-docs-all [] 
  (get-docs-joined))
  
(defn get_docs [(annotate sort-by SortKey) 
                (annotate sort-key-value str)
                [page (Query 0)] 
                [num (Query 25)]] 
  (setv tuple-docs 
    (get-docs-joined-with-key sort-by.value (prep-d sort-key-value)))
  tuple-docs)

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
    (setattr author "author_id" None)
    (add-record author "author")
    (except [e IntegrityError]
      (setv resp 
        (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)

(defn get-author-all [] 
  (get-authors-joined))

(defn get-author [[page (Query 0)] [num (Query 25)]] 
  (setv tuple-docs 
    (get-data-part "author" page num))
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
    (setattr dep "department_id" None)
    (add-record dep "departments")
    (except [e IntegrityError]
      (setv resp 
            (JSONResponse (dict :message (str e)) :status_code 400))))
  resp)

(defn get-department [[page (Query 0)] [num (Query 25)]] 
  (setv tuple-docs 
    (get-data-part "departments" page num))
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
(defn login-user [#^ str username #^ str password]
  (setv user (get-data-by-key 
               "users" "username" f"'{username}'" 0 1))
  (print user)
  (if (= user [])
      (setv resp (JSONResponse (dict :message "Not found") :status_code 404))
      (if (= password (get (get user 0) 3))
            (setv resp (JSONResponse (dict :message "ok" :is_admin (get (get user 0) 2))))
            (setv resp (JSONResponse (dict :message "Bad credentials") :status_code 400))))

  resp)
