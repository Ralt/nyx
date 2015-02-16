(in-package #:nyx)


(defun message-parse (raw-message)
  "Gets a message from a raw message, in the most common format"
  (format nil "~{~A~^ ~}" (cddr (cl-ppcre:split " " raw-message))))

(defun message-parse-privmsg (raw-message)
  "Parses a PRIVMSG message."
  (values "foo" "bar"))
