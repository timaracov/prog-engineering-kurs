(import enum [Enum])

(import pydantic [BaseModel])

;; апросы: по документам, по разработчикам, по отделам. 

(defclass SortKey [Enum]
  (setv 
    by_author "author_id"
    by_docs "name"
    by_depart "department_id"))


(defclass Document [BaseModel]
    #^ int doc_id
    #^ str name
    #^ str folder
    #^ str version
    #^ int author_id)


(defclass DocumentPOST [BaseModel]
    #^ str name
    #^ str folder
    #^ str version
    #^ int author_id)


(defclass DocumentGET [DocumentPOST]
	#^ int doc_id)
