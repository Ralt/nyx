(in-package #:nyx.lisp)


(defvar *connection*)
(defvar *dest*)
(defvar *messages* (make-hash-table :test #'equal))

(defun c (string)
  "Prepends ~ with ~ so that they're format'able"
  (cl-ppcre:regex-replace-all "~" string "~~"))

(defun send-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (list (quote send) (read stream nil t)))

;; So that we can use #i"send something"
(set-dispatch-macro-character #\# #\i #'send-reader)

(defun start (conn)
  (define-hooks)
  (nyx:connect conn)
  (setf *connection* conn))

(defun define-hooks ()
  "Defines all the hooks"
  (nyx:defhook privmsg (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (from to message)
        (nyx:message-parse-privmsg raw-message)
      (let ((m (format nil "<~A> ~A~%" from message)))
        (push m (gethash to *messages*))
        (when (string= *dest* to)
          (format t (c m))))))

  (nyx:defhook join (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (user chan)
        (nyx:message-parse-join raw-message)
      (let ((m (format nil "~A has joined ~A~%" user chan)))
        (push m (gethash chan *messages*))
        (when (string= *dest* chan)
          (format t (c m))))))

  (nyx:defhook part (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (user chan message)
        (nyx:message-parse-part raw-message)
      (let ((m (format nil "~A has left ~A: ~A~%" user chan message)))
        (push m (gethash chan *messages*))
        (when (string= *dest* chan)
          (format t (c m))))))

  (nyx:defhook quit (conn raw-message)
    (declare (ignore conn))
    (multiple-value-bind (user message)
        (nyx:message-parse-quit raw-message)
      (format t "~A has quit: ~A" user message))))

(defun join (dest)
  (if (gethash dest *messages*)
      (show-last-ten (gethash dest *messages*))
      (nyx:write *connection* (cat "JOIN " dest)))
  (setf *dest* dest))

(defun show-last-ten (messages)
  (loop for i from (if (< (length messages) 9) (- (length messages) 1) 9) downto 0
     do (princ (elt messages i))))

(defun send (msg)
  (nyx:write *connection* (cat "PRIVMSG " *dest* " :" msg))
  (let ((m (format nil "<~A> ~A" (nyx:nickname (nyx:network *connection*)) msg)))
    (push m (gethash *dest* *messages*))
    m))

(defun quit (&optional (msg ""))
  (setf *messages* (make-hash-table :test #'equal))
  (nyx:quit *connection* :message msg))
