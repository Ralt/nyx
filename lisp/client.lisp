(in-package #:nyx.lisp)


(defvar *connection*)
(defvar *dest*)

(defun start (conn)
  (define-hooks)
  (setf *connection* conn)
  (nyx:connect conn))

(defun define-hooks ()
  "Defines all the hooks"
  (nyx:defhook privmsg (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (from message)
        (nyx:message-parse-privmsg raw-message)
      (format t "<~A> ~A~%" from message))))

(defun join (dest)
  (nyx:socket-write (nyx:socket *connection*) (cat "JOIN " dest))
  (setf *dest* dest))

(defun send (msg)
  (nyx:socket-write (nyx:socket *connection*) (cat "PRIVMSG " *dest* " " msg)))
