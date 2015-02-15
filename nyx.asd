(asdf:defsystem #:nyx
  :description "Lisp IRC bouncer"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on ("usocket" "lparallel" "bordeaux-threads")
  :components ((:file "package")
               (:file "nyx")))
