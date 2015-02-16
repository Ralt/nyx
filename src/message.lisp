(in-package #:nyx)


(defun message-parse-ping (raw-message)
  "Parses a PING message."
  (format nil "~{~A~^ ~}" (cddr (cl-ppcre:split " " raw-message))))

(defun message-parse-privmsg (raw-message)
  "Parses a PRIVMSG message."
  (values "foo" "bar"))
