(import api [run-api])
(import db [create-tables])

(defn main []
  (create-tables)
  (run-api))

(cond (= __name__ "__main__") (main))
