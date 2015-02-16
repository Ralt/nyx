(in-package #:nyx)


(defclass connection ()
  ((network
    :documentation "The network to connect to"
    :initarg :network
    :initform (error "Must supply a network.")
    :reader network)
   (socket
    :documentation "The usocket socket"
    :accessor socket)
   (socket-stream
    :documentation "A stream usocket"
    :accessor socket-stream)))

(defmethod initialize-instance :after ((conn connection) &key)
  (unless (eq (type-of (network conn)) 'network)
    (error "network must be of type NETWORK.")))

(defmethod connect ((conn connection))
  "Connects to the network."
  (let ((network (network conn)))
    (setf (socket conn) (socket-create (server network) (port network)))
    (setf (socket-stream conn) (usocket:socket-stream (socket conn)))
    (bt:make-thread #'(lambda ()
                        (loop
                           (let ((message (socket-read (socket-stream conn))))
                             ;; Sometimes we get empty lines... ignore them
                             (when (> (length message) 0)
                               (hook-trigger conn message)))))
                    :name (cat "IRC connection for " (server network))
                    :initial-bindings (list (cons '*standard-output* *standard-output*)))
    (initialize-nickname conn)))

(defmethod initialize-nickname ((conn connection) &key)
  "Initializes the nickname"
  (let ((nickname (nickname (network conn))))
    (write conn (cat "NICK " nickname))
    (write conn (cat "USER " nickname " 8 * : " nickname))))

(defmethod write ((conn connection) msg &key)
  (socket-write (socket-stream conn) msg))

(defmethod quit ((conn connection) &key (message ""))
  (socket-write (socket-stream conn) (cat "QUIT :" message))
  (socket-close (socket conn)))
