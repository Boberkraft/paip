;; Write a function to exponentiate, or raise a number to an integer power.
;; For example: (power 3 2) = 32 = 9.



(defun power (base n)
  (cond ((zerop n) 1)
        (t (* base (power base (1- n))))))

(power 5 2)


(defun fast-power (base n)
  (cond ((zerop n) 1)
        ((evenp n) (power (* base base) (/ n 2)))
        (t (* base (power base (1- n))))))

(fast-power 5 2)
