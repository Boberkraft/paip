(load "main-role-based.list")

;; Write a version of generate that uses cond but avoids calling rewrites twice.

(defun generate3 (phrase)
  (let ((choice))
    (cond ((listp phrase) (mappend #'generate phrase))
          ((setf choice (rewrites phrase))
           (generate (random-elt choice)))
          (t (list phrase)))))
