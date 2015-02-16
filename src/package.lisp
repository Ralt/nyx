(defpackage #:nyx
  (:use #:cl)
  (:shadow :write :quit)
  (:export :main

           ;; hooks
           :defhook
           :*show-unhandled*

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
           :message-parse-join
           :message-parse-part
           :message-parse-quit
           :message-parse-ping))

(in-package #:nyx)


(defun cat (&rest args)
  (apply #'concatenate 'string args))
