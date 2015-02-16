(defpackage #:nyx
  (:use #:cl)
  (:shadowing-import-from :cl :write)
  (:export :main

           ;; misc
           :defhook

           ;; classes
           :connection
           :network

           ;; connection slots
           :connect
           :write
           :close

           ;; network slots
           :nickname
           :server
           :port

           ;; message goodies
           :message-parse-privmsg
           :message-parse-ping))

(in-package #:nyx)


(defun cat (&rest args)
  (apply #'concatenate 'string args))
