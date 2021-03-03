(defun find-all (item sequence &rest keyword-args
                 &key (test #'eql) test-not &allow-other-keys)
  "Find all those elements of sequence that match item,
  according to the keywords.  Doesn't alter sequence."
  (if test-not
      (apply #'remove item sequence
             (append keyword-args
                     (list :test-not (complement test-not)) ))

      (apply #'remove item sequence
             (append keyword-args
                     (list :test (complement test))))))

(setf nums '(1 2 3 2 1))

(find-all 1 nums :test #'equal :key #'abs)
(find-all 1 nums :test-not #'= :key #'abs)

;; ye?
