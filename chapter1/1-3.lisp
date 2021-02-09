;; Write a function that counts the number of atoms in an expression.
;; For example: (count-atoms '(a (b) c)) = 3.
;; Notice that there is something of an ambiguity in this:
;; should (a nil c) count as three atoms, or as two,
;; because it is equivalent to (a () c)?

(defun count-atoms (list)
  (cond ((null list) 0)
        ((atom list) 1)
        (t (+ (count-atoms (rest list))
              (count-atoms (first list))))))


(count-atoms '(a (b c) c))

(count-atoms '(1))

(count-atoms '(a nil))

