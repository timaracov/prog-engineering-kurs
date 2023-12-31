(ns kur.dto)

(defrecord Document 
  [doc_id name version dst_folder created_at author_id])
(defrecord Author 
  [author_id fullname education univercity department_id])
(defrecord Department 
  [department_id name location head phone_number])
