(defpackage #:nyx
  (:use #:cl)
  (:shadowing-import-from :cl :write)
  (:export :main
           :defhook
           :connection
           :network
           :connect
           :message-parse-privmsg
           :write
           :close))

(in-package #:nyx)


(defun cat (&rest args)
  (apply #'concatenate 'string args))
