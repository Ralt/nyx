(defpackage #:nyx
  (:use #:cl)
  (:shadow :write :quit)
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
           :quit

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
