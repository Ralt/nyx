(in-package #:nyx)


(defclass connection ()
  ((incoming-queue
    :documentation "The incoming messages queue"
    :initform (lparallel.queue:make-queue)
    :reader incoming-queue)
   (outgoing-queue
    :documentation "The ougoing messages queue"
    :initform (lparallel.queue:make-queue)
    :reader outgoing-queue)
   (network
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
                           (lparallel.queue:push-queue (socket-read socket)
                                                       (incoming-queue conn))))
                    :name (cat "Incoming loop for " (server network)))
    (bt:make-thread #'(lambda ()
                        (loop
                           (hook-trigger
                            (lparallel.queue:pop-queue (outgoing-queue conn)))))
                    :name (cat "Outgoing loop for " (server network)))
    (initialize-nickname conn)))

(defun initialize-nickname ((conn connection))
  "Initializes the nickname"
  (socket-write socket (cat "NICK " nickname))
  (socket-write socket (cat "USER " nickname " 8 * : " nickname)))
