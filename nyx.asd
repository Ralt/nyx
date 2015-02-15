(asdf:defsystem #:nyx
  :description "Lisp IRC bouncer"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on ("usocket" "lparallel" "bordeaux-threads" "cl-ppcre")
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "socket")
                         (:file "hook")
                         (:file "network")
                         (:file "connection")
                         (:file "nyx")))))
