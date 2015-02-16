(in-package #:nyx)


(defvar *hooks* (make-hash-table :test 'equal))

(defun hook-trigger (conn raw-message)
  "Finds the hooks to trigger for an IRC raw message."
  (multiple-value-bind (val presentp)
      (gethash (string-upcase (get-command raw-message)) *hooks*)
    ;; @debug
    (format t "COMMAND: ~A~%" (get-command raw-message))
    (if presentp
        (funcall val conn raw-message)
        (format t "UNHANDLED: ~A~%" raw-message))))

(defun get-command (raw-message)
  "Gets the command in a raw message."
  (multiple-value-bind (_ matches)
      (cl-ppcre:scan-to-strings "^.* (\\w+) .*$" raw-message)
    (declare (ignore _))
    (elt matches 0)))

(defmacro defhook (name vars &body body)
  "Defines hooks"
  `(setf (gethash (symbol-name ',name) *hooks*)
         #'(lambda ,vars
             ,@body)))

(defhook ping (conn raw-message)
  "Answers the PING commands"
  ;; @debug
  (format t "PING received: ~A~%" (message-parse-ping raw-message))
  (socket-write (socket-stream conn) (cat "PONG " (message-parse-ping raw-message))))
