(in-package #:nyx.lisp)


(defvar *connection*)
(defvar *dest*)

(defun send-reader (stream char)
  (declare (ignore char))
  (list (quote send) (read stream nil t)))

;; So that we can use i"send something"
(set-macro-character #\i #'send-reader)

(defun start (conn)
  (define-hooks)
  (nyx:connect conn)
  (setf *connection* conn))

(defun define-hooks ()
  "Defines all the hooks"
  (nyx:defhook privmsg (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (from message)
        (nyx:message-parse-privmsg raw-message)
      (format t "<~A> ~A~%" from message))))

(defun join (dest)
  (nyx:write *connection* (cat "JOIN " dest))
  (setf *dest* dest))

(defun send (msg)
  (nyx:write *connection* (cat "PRIVMSG " *dest* " :" msg))
  (format nil "<~A> ~A" (nyx:nickname (nyx:network *connection*)) msg))

(defun quit (&optional (msg ""))
  (nyx:close *connection* msg))
