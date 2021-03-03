;; Given the following initialization for the lexical variable a and the special variable *b*, what will be the value of the let form?

(setf a 'global-a)
(defvar *b* 'global-b)

(defun fn () *b*)

(let ((a 'local-a)
      (*b* 'local-b))
  (list a *b* (fn) (symbol-value 'a) (symbol-value '*b*))


  
