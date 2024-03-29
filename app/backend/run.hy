(import api [run-api])
(import db [create-tables prepare-db])

(defn main []
  (prepare-db)
  (run-api))

(cond (= __name__ "__main__") (main))
