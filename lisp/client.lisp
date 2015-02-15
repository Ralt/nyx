(in-package #:nyx.lisp)


(defvar *dest*)

(defun start (conn)
  (define-hooks)
  (nyx:connect conn))

(defun define-hooks ()
  "Defines all the hooks"
  (nyx:defhook privmsg (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (_ matches)
        (cl-ppcre:scan-to-strings "^:(\\w+)!" raw-message)
      (declare (ignore _))
      (format t "<~A> ~A~%" (elt matches 0) (nyx:message-parse raw-message)))))

(defun join (dest)
  (nyx:socket-write (nyx:socket nyx:*connection*) (cat "JOIN " dest))
  (setf *dest* dest))

(defun send (msg)
  (nyx:socket-write (nyx:socket nyx:*connection*) (cat "PRIVMSG " *dest* " " msg)))
