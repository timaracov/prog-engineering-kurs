(import fastapi [FastAPI APIRouter Query])
(import uvicorn [run])
(import pydantic [BaseModel])

(import enum [Enum])

; models
(defclass Document [BaseModel]
  (setv 
    #^ str doc_id
    #^ str name
    #^ str folder
    #^ str version))

(defclass SortKey [Enum]
  (setv 
    by_author "author"
    by_docs "docs"
    by_depart "depart"))

(setv root (APIRouter :prefix "/api"))
(setv docrouter (APIRouter :prefix "/documents" :tags ["Documents"]))

; routers
(defn get_docs 
  [[page (Query 0)] 
   [num (Query 25)]
   [sort_key #^ SortKey SortKey.by_docs]] 
  (print 123))

(defn update_doc [#^ str doc_id data] 
  (print "up"))

(defn delete_doc [#^ str doc_id]
  (print "dl"))

; set routers
(docrouter.add_api_route 
  "/documents" 
  get_docs 
  :methods ["GET"])

(docrouter.add_api_route 
  "/documents/{doc_id}" 
  update_doc 
  :methods ["PUT"])

(docrouter.add_api_route 
  "/documents/{doc_id}" 
  delete_doc 
  :methods ["DELETE"])

; create app
(setv api (FastAPI))
(root.include_router docrouter)
(api.include_router root)

; entrypoint
(cond 
  (= __name__ "__main__")
    (run api))
