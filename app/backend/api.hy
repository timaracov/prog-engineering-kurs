(import fastapi [FastAPI APIRouter Query])
(import fastapi.middleware.cors [CORSMiddleware])
(import uvicorn [run])

(import handlers *)

(setv root 
  (APIRouter :prefix "/api"))
(setv auth_router
  (APIRouter :prefix "/auth" :tags ["Auth"]))
(setv docrouter
  (APIRouter :prefix "/documents" :tags ["Documents"]))
(setv author_router 
  (APIRouter :prefix "/authors" :tags ["Authors"]))
(setv department_router
  (APIRouter :prefix "/departments" :tags ["Deparments"]))

(docrouter.add_api_route 
  "" 
  add-docs :methods ["POST"])
(docrouter.add_api_route 
  "" 
  get_docs :methods ["GET"])
(docrouter.add_api_route 
  "/joined" 
  get-docs-all :methods ["GET"])
(docrouter.add_api_route 
  "/{doc_id}" 
  update_doc :methods ["PUT"])
(docrouter.add_api_route 
  "/{doc_id}" 
  delete_doc :methods ["DELETE"])

(author_router.add_api_route 
  "" 
  add-author :methods ["POST"])
(author_router.add_api_route 
  "" 
  get-author :methods ["GET"])
(author_router.add_api_route 
  "/joined" 
  get-author-all :methods ["GET"])
(author_router.add_api_route 
  "/{author_id}" 
  update-author :methods ["PUT"])
(author_router.add_api_route 
  "/{author_id}" 
  delete-author :methods ["DELETE"])

(department_router.add_api_route 
  "" 
  add-department :methods ["POST"])
(department_router.add_api_route 
  "" 
  get-department :methods ["GET"])
(department_router.add_api_route 
  "/{dep_id}" 
  update-department :methods ["PUT"])
(department_router.add_api_route 
  "/{dep_id}" 
  delete-department :methods ["DELETE"])

(auth_router.add_api_route
  "/login/user"
  login-user :methods ["POST"])
(auth_router.add_api_route
  "/login/admin"
  login-admin :methods ["POST"])


(defn run-api []
  (setv api (FastAPI))
  (api.add_middleware 
  	CORSMiddleware
	:allow_origins ["*"]
	:allow_credentials True
	:allow_methods ["*"]
	:allow_headers ["*"])
  (root.include_router docrouter)
  (root.include_router author_router)
  (root.include_router department_router)
  (root.include_router auth_router)
  (api.include_router root)
  (run api))

