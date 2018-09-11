(in-package #:bank-example)

(defclass bank-account ()
  ((%customer-name :initarg :customer-name :accessor account-customer)
   (%balance :initarg :balance :accessor account-balance)
   (%type :reader account-type))
  (:documentation "Base class for all bank accounts"))

;; API
(defgeneric deposit (account amount)
  (:documentation "deposits money into account."))

(defgeneric withdraw (account amount)
  (:documentation "withdraws money from account"))

(defgeneric some-func (bank-account)
  (:method-combination progn :most-specific-last))

(defmethod deposit ((account bank-account) amount)
  (with-accessors ((balance account-balance)) account
    (setf balance (+ balance amount))))

(defmethod withdraw ((account bank-account) amount)
  (with-accessors ((balance account-balance)) account
    (setf balance (- balance amount))))

(defmethod some-func progn ((account bank-account))
  (print "base class some-func called"))
