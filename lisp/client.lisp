(in-package #:nyx.lisp)


(defvar *connection*)
(defvar *dest*)
(defvar *messages* (make-hash-table :test #'equal))

(defun send-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (list (quote send) (read stream nil t)))

;; So that we can use i"send something"
(set-dispatch-macro-character #\# #\i #'send-reader)

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
  (push msg (gethash *dest* *messages*))
  (format nil "<~A> ~A" (nyx:nickname (nyx:network *connection*)) msg))

(defun quit (&optional (msg ""))
  (nyx:close *connection* msg))
