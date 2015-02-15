(in-package #:nyx)


(defclass connection ()
  ((network
    :documentation "The network to connect to"
    :initarg :network
    :initform (error "Must supply a network.")
    :reader network)
   (socket
    :documentation "The usocket socket"
    :accessor socket)))

(defmethod initialize-instance :after ((conn connection) &key)
  (unless (eq (type-of (network conn)) 'network)
    (error "network must be of type NETWORK."))
  (setf *connection* conn))

(defmethod connect ((conn connection))
  "Connects to the network."
  (let ((network (network conn)))
    (setf (socket conn) (socket-create (server network) (port network)))
    (bt:make-thread #'(lambda ()
                        (loop
                           (hook-trigger conn (socket-read (socket conn)))))
                    :name (cat "IRC connection for " (server network))
                    :initial-bindings (list (cons '*standard-output* *standard-output*)))
    (initialize-nickname conn)))

(defmethod initialize-nickname ((conn connection))
  "Initializes the nickname"
  (let ((socket (socket conn))
        (nickname (nickname (network conn))))
    (socket-write socket (cat "NICK " nickname))
    (socket-write socket (cat "USER " nickname " 8 * : " nickname))))
