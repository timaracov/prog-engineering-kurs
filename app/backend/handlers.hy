(import fastapi [Query])

(import models [Document SortKey])

;; DOCS
(defn add-docs [#^ Document doc]
  (doc.model_dump))
(defn get_docs [(annotate sort_by SortKey) 
                [page (Query 0)] 
                [num (Query 25)]] 
  [page num sort_by.value])
(defn update_doc [#^ str doc_id 
                  #^ Document data] 
  [doc_id data])
(defn delete_doc [#^ str doc_id]
  doc_id)

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
