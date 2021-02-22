;; Write a function that will print an expression in dotted pair notation.
;; Use the built-in function princ to print each component of the expression.

(defun printdoted (lst)
  (when (not (consp (rest lst)))
    (princ "."))

  (if (listp (first lst))
      (progn (princ "(")
             (printdoted (first lst))
             (princ ")"))
      (progn (princ " ")
             (princ (first lst))
             (princ " ")))
  (when (consp (rest lst))
    (printdoted (rest lst))))


(printdoted '( 1 2 3 ( b c d ) a ( l)))

(defun dprint (x)
  "Print an expression in dotted pair notation."
  (cond ((atom x) (princ x))
        (t (princ "(")
           (dprint (first x))
           (pr-rest (rest x))
           (princ ")")
           x)))

(defun pr-rest (x)
  (princ " . ")
  (dprint x))

(dprint '( 1 2 3 ( b c d ) a ( l)))
