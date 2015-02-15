(in-package #:nyx)


(defclass connection ()
  ((network
    :documentation "The network to connect to"
    :initarg :network
    :initform (error "Must supply a network.")
    :reader network)
   (socket
    :documentation "The usocket socket"
    :reader socket)))

(defmethod initialize-instance :after ((conn connection) &key)
  (unless (eq (type-of (network conn)) 'network)
    (error "network must be of type NETWORK."))
  (setf *connection* conn))

(defmethod connect ((conn connection))
  "Connects to the network."
  (let* ((socket (socket conn))
         (network (network conn))
         (nickname (nickname network)))
    (setf socket (socket-create (server network) (port network)))
    (bt:make-thread #'(lambda ()
                        (loop
                           (hook-trigger (socket-read socket))))
                    :name (cat "IRC connection for " (server network)))
    (initialize-nickname conn)))

(defmethod initialize-nickname ((conn connection))
  "Initializes the nickname"
  (let ((socket (socket conn)))
    (socket-write conn (cat "NICK " nickname))
    (socket-write conn (cat "USER " nickname " 8 * : " nickname))))
