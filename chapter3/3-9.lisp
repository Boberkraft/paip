;; Write a version of length using the function reduce 

(defun my-length (lst)
  (let ((acc (if (null lst) 0 1)))
    (reduce (lambda (a b)
              (incf acc))
            lst)))

(defun my-length1 (lst)
  (reduce ( lambda (a b)
            (+ a 1))
          lst
          :initial-value 0))

(my-length '(1 2 3 4))
(my-length1 '(1))

