(defpackage #:nyx
  (:use #:cl))

(in-package #:nyx)


(defvar *connection*)

(defun cat (&rest args)
  (apply #'concatenate 'string args))
