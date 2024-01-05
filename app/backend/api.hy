(import enum [Enum])
(import fastapi [FastAPI APIRouter Query])
(import uvicorn [run])
(import models [Document])

(defclass SortKey [Enum]
  (setv 
    by_author "author_id"
    by_docs "name"
    by_depart "depart"))

(setv root (APIRouter :prefix "/api"))
(setv docrouter (APIRouter :prefix "/documents" :tags ["Documents"]))
(setv author_router (APIRouter :prefix "/authors" :tags ["Authors"]))
(setv department_router (APIRouter :prefix "/deparments" :tags ["Deparments"]))

; routers
(defn add-docs [#^ Document doc]
  (doc.model_dump))

(defn get_docs [(annotate sort_by SortKey) 
                [page (Query 0)] 
                [num (Query 25)]] 
  [page num sort_by.value])

(defn update_doc [#^ str doc_id #^ Document data] 
  [doc_id data])

(defn delete_doc [#^ str doc_id]
  doc_id)

; set routers
(docrouter.add_api_route 
  "" 
  add-docs
  :methods ["POST"])
(docrouter.add_api_route 
  "" 
  get_docs 
  :methods ["GET"])
(docrouter.add_api_route 
  "/{doc_id}" 
  update_doc
  :methods ["PUT"])
(docrouter.add_api_route 
  "/{doc_id}" 
  delete_doc 
  :methods ["DELETE"])


; create app
(setv api (FastAPI))
(root.include_router docrouter)
(root.include_router author_router)
(root.include_router department_router)
(api.include_router root)

; entrypoint
(cond 
  (= __name__ "__main__")
    (run api))
