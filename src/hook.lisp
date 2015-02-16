(in-package #:nyx)


(defvar *hooks* (make-hash-table :test 'equal))
(defvar *show-unhandled* nil)

(defun hook-trigger (conn raw-message)
  "Finds the hooks to trigger for an IRC raw message."
  (multiple-value-bind (val presentp)
      (gethash (string-upcase (get-command raw-message)) *hooks*)
    (if presentp
        (funcall val conn raw-message)
        (when *show-unhandled* (format t "UNHANDLED: ~A~%" raw-message)))))

(defun get-command (raw-message)
  "Gets the command in a raw message."
  ;; Special cases: PING and ERROR
  (let ((parts (cl-ppcre:split " " raw-message)))
    (when (string= (string-upcase (first parts)) "PING")
      (return-from get-command "PING"))
    (when (string= (string-upcase (first parts)) "ERROR")
      (return-from get-command "ERROR"))
    (second (cl-ppcre:split " " raw-message))))


(defmacro defhook (name vars &body body)
  "Defines hooks"
  `(setf (gethash (symbol-name ',name) *hooks*)
         #'(lambda ,vars
             ,@body)))

(defhook ping (conn raw-message)
  "Answers the PING commands"
  (socket-write (socket-stream conn) (cat "PONG " (message-parse-ping raw-message))))
