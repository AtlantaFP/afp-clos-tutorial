(in-package #:bank-example)

(defclass bank-account ()
  ((%customer-name :initarg :customer-name :accessor account-customer)
   (%balance :initarg :balance :accessor account-balance)
   (%type :reader account-type))
  (:documentation "Base class for all bank accounts"))

(defclass savings-account (bank-account)
  ((%overdraft-p :initform nil :reader account-overdraft-p)
   (%savings-interest-rate :initform .05)))

(afp-utils:define-printer (savings-account stream)
  (format stream "~A" (account-type savings-account)))

;; API
(defgeneric deposit (account amount)
  (:documentation "deposits money into account."))

(defgeneric withdraw (account amount)
  (:documentation "withdraws money from account"))

(defun open-savings-account (customer-name balance)
  (make-instance 'savings-account :customer-name customer-name
                 :balance balance))

(defun update-savings-account-type (account)
  (with-slots (%type) account
    (with-accessors ((balance account-balance)) account
      (cond ((<= balance 1000) (setf %type :basic))
            ((> balance 1000) (setf %type :premium))))))

(defmethod initialize-instance :after ((account savings-account) &rest initargs)
  (declare (ignore initargs))
  (update-savings-account-type account))

(defmethod deposit ((account bank-account) amount)
  (with-accessors ((balance account-balance)) account
    (setf balance (+ balance amount))))

(defmethod withdraw ((account bank-account) amount)
  (with-accessors ((balance account-balance)) account
    (setf balance (- balance amount))))

