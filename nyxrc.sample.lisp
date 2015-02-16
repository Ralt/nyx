(in-package #:nyx.lisp)

(let ((conn (make-instance
             'nyx:connection
             :network (make-instance
                       'nyx:network
                       :server "irc.freenode.net"
                       :port 6667
                       :nickname "Ralt_"))))
  (start conn))
