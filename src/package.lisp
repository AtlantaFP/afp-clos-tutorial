;;
;; This package defines a simple API for a banking application
;; that deals with deposits and withdrawals into a checking and
;; savings account respectively.
;;
(defpackage #:bank-example
  (:use :cl :afp-utils)
  (:export #:open-checking-account
           #:open-savings-account
           #:deposit
           #:withdraw))
