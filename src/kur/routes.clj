(ns kur.routes
  (:require [compojure.core :refer :all]
            [compojure.route :as route]))

(defroutes general-routes 
  (GET "/" params "<h1>Main page</h1>")
  (route/not-found "<h1>Not Found</h1>"))

(defroutes docs-routes
  (GET "/documents" params "")
  (POST "/documents" params "")
  (DELETE "/documents/:doc-id" params ""))

(defroutes users-routes 
  (GET "/user/auth/check" params ""))
