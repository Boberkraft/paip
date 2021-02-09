;; Write a function that counts the number of times an expression occurs anywhere within another expression.
;; Example: (count-anywhere 'a '(a ((a) b) a)) => 3.

(defun count-anywhere (niddle hay)
  (cond
    ((equal niddle hay) 1)
    ((atom hay) 0)
    (t (+ (count-anywhere niddle (first hay))
          (count-anywhere niddle (rest hay))))))

(count-anywhere 'a '(a ((a) b) a))
