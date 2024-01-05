(import fastapi [FastAPI APIRouter])
(import uvicorn [run])
(import pydantic [BaseModel])

; models
(defclass Document [BaseModel]
  (setv 
    #^ str doc_id
    #^ str name
    #^ str folder
    #^ str version))

(setv root (APIRouter :prefix "/api"))
(setv docrouter (APIRouter :prefix "/documents"))

; routers
(defn get_docs [[page 3] [num 25]] 
  (print 123))

; set routers
(docrouter.add_api_route 
  "/documents" 
  get_docs 
  :methods ["GET"])

; create app
(setv api (FastAPI))
(root.include_router docrouter)
(api.include_router root)

; entrypoint
(cond 
  (= __name__ "__main__")
    (run api))
