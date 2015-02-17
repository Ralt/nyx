(in-package #:nyx)


(defclass network ()
  ((server
    :documentation "The server hostname. As long as nyx doesn't support sqlite."
    :initarg :server
    :initform (error "Must supply a server.")
    :reader server)
   (port
    :documentation "The port value. As long as nyx doesn't support sqlite."
    :initarg :port
    :initform (error "Must supply a port.")
    :reader port)
   (nickname
    :documentation "The nickname to have on the network."
    :initarg :nickname
    :initform (error "Must supply a nickname.")
    :accessor nickname)
   (password
    :documentation "The password of the network."
    :initarg :password
    :initform ""
    :accessor password)))
