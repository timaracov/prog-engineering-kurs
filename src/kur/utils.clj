(ns kur.utils)

(defn get-timestamp [] 
  (quot (System/currentTimeMillis) 1000))
