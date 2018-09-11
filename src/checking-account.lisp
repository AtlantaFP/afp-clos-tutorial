(in-package #:bank-example)

(defclass checking-account (bank-account)
  ((%overdraft-p :initform nil :reader account-overdraft-p)
   (%minmum-balance :initform 1000
                    :reader checking-account-minimum-balance
                    :allocation :class)))

(afp-utils:define-printer (checking-account stream)
  (format stream "~A" (account-type checking-account)))

;; constructor
(defun open-checking-account (customer-name balance)
  (make-instance 'checking-account :customer-name customer-name
                                   :balance balance))

;;
;; helper function to determine type of account based
;; on balance.
;; updating account type as we deposit / withdraw money from
;; account.
;;

(defun update-checking-account-type (account)
  (with-slots (%type) account
    (let ((balance (account-balance account)))
        (cond
          ((< balance 1000) (setf %type :basic))
          ((<= 1000 balance 10000) (setf %type :premium))
          ((> balance 10000) (setf %type :platinum))))))

(defmethod initialize-instance :after ((account checking-account) &rest initargs)
  (declare (ignore initargs))
  (update-checking-account-type account))

;; defining an after method so that we can update the account information
;; upon completion of a deposit as well as withdrawal
(defmethod deposit :after ((account checking-account) amount)
  (update-checking-account-type account))

(defmethod withdraw :after ((account checking-account) amount)
  (update-checking-account-type account))

(defmethod withdraw :around ((account checking-account) amount)
  (with-slots (%overdraft-p) account
    (if %overdraft-p
        (error "You already withdrew beyond your minimum balance")
        (when (< (- (account-balance account) amount) (checking-account-minimum-balance account))
          (setf %overdraft-p t)))
    (call-next-method)))
