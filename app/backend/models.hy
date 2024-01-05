(import pydantic [BaseModel])

; models
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
