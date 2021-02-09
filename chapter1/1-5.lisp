;; Write a function to compute the dot product of two sequences of numbers, represented as lists.
;; The dot product is computed by multiplying corresponding elements and then adding up the resulting products.
;; Example:
;; (dot-product '(10 20) '(3 4)) = 10 x 3 + 20 x 4 = 110



(defun dot-product (x y)
  (if (null x)
      0
      (+ (* (first x) (first y))
         (dot-product (rest x) (rest y)))))

(dot-product '(10 20) '(3 4))


