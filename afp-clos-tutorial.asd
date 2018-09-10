(asdf:defsystem #:afp-clos-tutorial
  :description "A tutorial on using the Common Lisp Object System"
  :author ("Ram Vedam")
  :license "MIT"
  :version "0.1.0"
  :depends-on ("afp-utils")
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "bank-accounts")
   (:file "checking-account")
   (:file "savings-account")))
