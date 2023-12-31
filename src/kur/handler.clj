;; ПС «Управление конфигурацией». 
;; Система для накопления, просмотра и модификации информации о
;; формируемом документообороте в процессе проектирования программного 
;; продукту. Оперируемая информация: название документа, его версия, 
;; папка хранения, дата создания, ФИО автора документа, его образование,
;; вуз, отдел работы, расположение отдела, руководитель отдела, 
;; телефон отдела. 
;; Запросы: по документам, по разработчикам, по отделам.  

(ns kur.handler
  (:require kur.utils :as utils)
  (:require [compojure.core :refer :all]
            [compojure.route :as route]))


(defn get-docs [request] "")

(defn create-doc [request] "")

