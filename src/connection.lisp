(in-package #:nyx)


(defclass connection ()
  ((incoming-queue
    :documentation "The incoming messages queue"
    :initarg :incoming-queue
    :initform *incoming-queue*
    :accessor incoming-queue)
   (outgoing-queue
    :documentation "The ougoing messages queue"
    :initarg :outgoing-queue
    :initform *outgoing-queue*
    :accessor outgoing-queue)
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
                           (trigger-hooks
                            (lparallel.queue:pop-queue (outgoing-queue conn)))))
                    :name (cat "Outgoing loop for " (server network)))
    (socket-write socket (cat "NICK " nickname))
    (socket-write socket (cat "USER " nickname " 8 * : " nickname))))
