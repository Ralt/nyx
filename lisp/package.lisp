(defpackage #:nyx.lisp
  (:use #:cl))


(in-package #:nyx.lisp)

(defun cat (&rest args)
  (apply #'concatenate 'string args))
