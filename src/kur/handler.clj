(ns kur.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]))

;; ПС «Управление конфигурацией». 
;; Система для накопления, просмотра и модификации информации о
;; формируемом документообороте в процессе проектирования программного 
;; продукту. Оперируемая информация: название документа, его версия, 
;; папка хранения, дата создания, ФИО автора документа, его образование,
;; вуз, отдел работы, расположение отдела, руководитель отдела, 
;; телефон отдела. Запросы: по документам, по разработчикам, по отделам.  

(defrecord Document [doc_id name version dst_folder created_at author_id])
(defrecord Author [author_id fullname education univercity department_id])
(defrecord Department [department_id name location head phone_number])


(defn get-timestamp [] 
  (quot (System/currentTimeMillis) 1000))


(defn get-docs [] 
  (str (Document. 
         1 "ESPD" "0.0.1" "/etc/xdoc/espd.md" (get-timestamp) 2)))

(defn create-doc [doc-json] "ok")


(defroutes app-routes
  (GET "/" [] "Main page")
  (GET "/documents" [] (get-docs))
  (POST "/documents" [] (str :fuck-you))
  (route/not-found "Not Found"))

(def app
  (wrap-defaults app-routes site-defaults))
