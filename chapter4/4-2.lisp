;; Write a function that generates all permutations of its input.

(setf x 100)
(defun permutations (lst)
  (if (zerop (decf x))
      raise)
  (if (null lst)
      '(nil)
      (mapcan (lambda (element)
                (mapcar (lambda (rest)
                          (list* element rest))
                        (permutations (remove element lst :test #'eq :count 1)))
                )
              lst)))

(permutations '(1 4 2 'a))
