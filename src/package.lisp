(defpackage #:nyx
  (:use #:cl))

(in-package #:nyx)


(defvar *incoming-queue*)
(defvar *outgoing-queue*)
(defvar *connection*)

(defun cat (&rest args)
  (apply #'concatenate 'string args))
