;; One way of describing combine-all is that it calculates the cross-product of the function append on the argument lists.
;; Write the higher-order function cross-product, and define combine-all in terms of it.

(defun cross-product (fn x y)
  (mapcar (lambda (x-element)
            (mapcar (lambda (y-element)
                      (funcall fn x-element y-element))
                    y))
          x))


(cross-product #'list '(1 2 3) '(10 20 30))
(cross-product #'append '((9) (2) (3)) '((10) (20) (30)))



(apply #'append '((a b) (c d) (e f)))


(apply #'append (cross-product #'append '((9) (2) (3)) '((10) (20) (30))))
