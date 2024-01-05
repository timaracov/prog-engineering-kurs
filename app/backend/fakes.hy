(import os)
(import uuid [uuid4])
(import faker [Faker])

(setv fk (Faker))

(defn replace-file-in-path [path filename]
  (os.path.join 
    ((. "/" join)
     (cut 
       ((. path split) "/") 
       0 -1))
    filename))

(defn generate-fake-document []
  (setv file (fk.file_name))
  (setv filepath 
    (replace-file-in-path 
      (fk.file_path :depth 3) file))
  (dict 
    :doc_id (str (uuid4))
    :name file
    :folder filepath
    :version (fk.isbn10)))


(print (generate-fake-document))
(print (replace-file-in-path "/files/f/file.txt" "ikd.md"))
