(in-package #:bank-example)

(defclass savings-account (bank-account)
  ((%overdraft-p :initform nil :reader account-overdraft-p)
   (%savings-interest-rate :initform .05)))


(afp-utils:define-printer (savings-account stream)
  (format stream "~A" (account-type savings-account)))

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

;; defining an after method so that we can update the account information
;; upon completion of a deposit as well as withdrawal
(defmethod deposit :after ((account savings-account) amount)
  (update-savings-account-type account))

(defmethod withdraw :after ((account savings-account) amount)
  (update-savings-account-type account))

(defmethod withdraw ((account savings-account) amount)
  (print "foo. this shouldn't be called."))

;;
;; (multiple-value-prog1
;;  (progn (most-specific-before-method args)
;;         (least-specific-before-method args)
;;         (most-specific-primary-method args))
;;  (least-specific-after-method args)
;;  (most-specific-after-method args))

;;
;; (operator (primary-method-1 args)
;;           (primary-method-2 args)
;;           (primary-method-3 args))
;;

;;
;; progn, +, and, or, append, list

(defmethod some-func progn ((account savings-account))
  (print "savings account  some-func called"))
