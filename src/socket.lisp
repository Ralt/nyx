(in-package #:nyx)


(defun socket-create (server port)
  "Creates a socket"
  (usocket:socket-stream (usocket:socket-connect server port)))

(defun socket-read (socket)
  "Reads a line in the socket"
  (read-line socket nil))

(defun socket-write (socket string)
  "Writes a line in the socket"
  (write-line string socket)
  (force-output socket))
