(defpackage #:bank-example
  (:use :cl :afp-utils)
  (:export #:open-checking-account
           #:open-savings-account
           #:deposit
           #:withdraw))
