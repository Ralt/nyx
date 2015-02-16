(in-package #:nyx)


(defun message-parse-ping (raw-message)
  "Parses a PING message."
  (format nil "~{~A~^ ~}" (cdr (cl-ppcre:split " " raw-message))))

(defun message-parse-privmsg (raw-message)
  "Parses a PRIVMSG message."
  (let* ((parts (cl-ppcre:split " " raw-message))
         (username (message-get-username (first parts)))
         ;; Remove the leading :
         (message (subseq (format nil "~{~A~^ ~}" (cdddr parts)) 1)))
    ;; (values user chan message)
    (values username (third parts) (remove-^M message))))

(defun message-get-username (user)
  "Gets the username in a part like :<username>!...@..."
  (multiple-value-bind (_ matches)
      (cl-ppcre:scan-to-strings ":(\\w+)!.*" user)
    (declare (ignore _))
    (elt matches 0)))

(defun message-parse-join (raw-message)
  "Parses a JOIN raw message"
  (let ((parts (cl-ppcre:split " " raw-message)))
    ;; (values user chan)
    (values (subseq (first parts) 1)
            (remove-^M (third parts)))))

(defun message-parse-part (raw-message)
  "Parses a PART raw message"
  (let ((parts (cl-ppcre:split " " raw-message)))
    ;; (values user chan message)
    (values (subseq (first parts) 1)
            (third parts)
            (subseq (remove-^M (format nil "~{~A~^ ~}" (cdddr parts))) 1))))

(defun message-parse-quit (raw-message)
  "Parses a QUIT raw message"
  (let ((parts (cl-ppcre:split " " raw-message)))
    ;; (values user message)
    (values (subseq (first parts) 1)
            (subseq (remove-^M (format nil "~{~A~^ ~}" (cddr parts))) 1))))

(defun remove-^M (string)
  (subseq string 0 (- (length string) 1)))
