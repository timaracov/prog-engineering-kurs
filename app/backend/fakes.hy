(import os)
(import uuid [uuid4])
(import random [randint choice])
(import faker [Faker])
(import models *)

(setv fk (Faker))

(defn replace-file-in-path [path filename]
  (os.path.join 
    ((. "/" join)
     (cut 
       ((. path split) "/") 
       0 -1))
    filename))

(defn gen-fake-uni []
  (setv cap-lts "QWERTYUIOPASDFFGJHKLZXCVBNM")
  (+ (choice cap-lts)
     (choice cap-lts)
     (choice cap-lts)))

(defn generate-fake-document []
  (setv file (fk.file_name))
  (setv filepath 
    (replace-file-in-path 
      (fk.file_path :depth 3) file))
  (dict 
    :doc_id (str (uuid4))
    :name file
    :folder filepath
    :version (fk.isbn10)
    :author (randint 0 15)))

(defn generate-fake-author [] 
  (dict 
    :author_id (str (uuid4))
    :fullname (fk.name)
    :education (choice ["среднее" 
                        "среднее профессиональное" 
                        "высшее 1 степени" 
                        "высшее 2 степени"])
    :university (gen-fake-uni)
    :department (randint 0 15)))

(defn generate-fake-department [] 
  (dict 
    :department_id (str (uuid4))
    :name (fk.company)
    :location (fk.address)
    :head (fk.name)
    :phone (fk.phone_number)))

(defn generate-fake-user [] 
  (dict
    :user_id (str (uuid4))
    :username ((. 
                ((. (fk.name) lower))
                  replace) " " "_")
    :password (fk.isbn10)
    :is_admin (randint 0 1)))
