;; Write a function that, like the regular print function, will print an expression in dotted pair notation when necessary but will use normal list notation when possible.



(defun my-print (lst)
  (when (listp (first lst))
      (princ "(")
      (my-print (first lst))
      (print ")"))
  (when (atom (first lst))
    (princ (first lst))
    (my-print (rest lst)))
  (when (and (consp lst)
             (not (consp (rest lst))))
    (princ ".")
    (my-print (rest lst))
    )
  )



(my-print '(1 2 3 . ( 5 5 .7)))
