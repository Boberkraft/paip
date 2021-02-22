;; Write a function that, like the regular print function, will print an expression in dotted pair notation when necessary but will use normal list notation when possible.

(Setf x 100)

(defun my-print1 (Lst)
  (when (> 0 (decf x))
    (return my-print1))

  (cond ((null lst)
         (princ "nil"))
        ((atom lst)
         (princ lst))
        ((atom (first lst))
         (princ (first lst))
         (princ " ")
         (print-rest (rest lst)))
        ((listp (first lst))
         (princ "(")
         (my-print1 (first lst))
         (princ ") ")
         (print-rest (rest lst)))
        ))

(defun print-rest (lst)
  (cond
    ((atom lst)
     (princ " . "))
    (t
     (princ " ")))
  (my-print1 lst))

(my-print1 '(1 30 (t . b) (2 3) 3 (8 10 . 9) . ( 5 5 .7)))
