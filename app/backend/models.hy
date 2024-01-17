(import enum [Enum])

(import pydantic [BaseModel])

;; апросы: по документам, по разработчикам, по отделам. 

(defclass SortKey [Enum]
  (setv 
    by_author "author"
    by_docs "docs.name"
    by_depart "department"))


(defclass Document [BaseModel]
  #^ int doc_id
  #^ str name
  #^ str folder
  #^ str version
  #^ int author)


; (defclass DocumentPOST [BaseModel]
;   #^ str name
;   #^ str folder
;   #^ str version
;   #^ int author_id)
; 
; 
; (defclass DocumentGET [DocumentPOST]
;   #^ int doc_id)


(defclass Author [BaseModel]
  #^ int author_id
  #^ str fullname
  #^ str education
  #^ str university
  #^ int department)


(defclass Department [BaseModel]
  #^ int department_id
  #^ str name
  #^ str location
  #^ str head
  #^ str phone)


(defclass User [BaseModel]
  #^ int user_id
  #^ str username
  #^ str password
  #^ int is_admin)
