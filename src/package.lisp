(defpackage #:nyx
  (:use #:cl)
  (:export :defhook
           :connection
           :network
           :connect
           :message-parse
           :socket-write
           :socket
           :*connection*))

(in-package #:nyx)


(defvar *connection*)

(defun cat (&rest args)
  (apply #'concatenate 'string args))
