(in-package #:nyx)


(defun message-parse-ping (raw-message)
  "Parses a PING message."
  (format nil "~{~A~^ ~}" (cdr (cl-ppcre:split " " raw-message))))

(defun message-parse-privmsg (raw-message)
  "Parses a PRIVMSG message."
  (let* ((parts (cl-ppcre:split " " raw-message))
         (username (message-get-username (first parts))))
    (values username (subseq (format nil "~{~A~^ ~}" (cdddr parts)) 1))))

(defun message-get-username (user)
  "Gets the username in a part like :<username>!...@..."
  (multiple-value-bind (_ matches)
      (cl-ppcre:scan-to-strings ":(\\w+)!.*" user)
    (declare (ignore _))
    (elt matches 0)))
