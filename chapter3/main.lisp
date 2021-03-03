
(defun length1 (list)
  (let ((len 0))
    (dolist (element list)
      (incf len))
    len))

(defun length1.1 (list)
  (let ((len 0))
    (dolist (element list len)
      (incf len))))


(defun length2 (list)
  (let ((len 0))
    (mapc #'(lambda (element)
              (incf len))
          list)
    len))

(defun length3 (list)
  (do ((len 0 (+ len 1))
       (l list (rest l)))
      ((null l) len)))

(defun length4 (list)
  (loop for element in list
        count t))

(defun length5 (list)
  (loop for element in list
        summing 1))

(defun length6 (list)
  (loop with len = 0
        until (null list)
        for element = (pop list)
        do (incf len)
        finally (return len)))

(defun length7 (list)
  (count-if #'true list))

(defun true (x) t)


(defun length8 (list)
  (if (null list)
      0
      (+ 1
         (position-if #'true list :from-end t))))

(defun length9 (list)
  (if (null list)
      0
      (+ 1 (length (rest list)))))

(defun length10 (list)
  (length10-aux list 0))

(defun length10-aux (sublist len-so-far)
  (if (null sublist)
      len-so-far
      (length10-aux (rest sublist)
                    (+ 1 len-so-far))))


(defun length11 (list &optional (len-so-far 0))
  (if (null list)
      len-so-far
      (length11 (rest list)
                (+ 1 len-so-far))))

(defun length12 (the-list)
  (labels
      ((length13 (list len-so-far)
         (if (null list)
             len-so-far
             (length13 (rest list)
                       (+ 1 len-so-far)))))
    (length13 the-list 0)))


(defun product (numbers)
  (let ((prod 1))
    (dolist (n numbers prod)
      (if (= n 0)
          (return 0)
          (setf prod (* n prod))))))


;; (product '(10 5))

(defmacro while (test &rest body)
  (list* 'loop
         (list 'unless test '(return nil))
         body))

(defmacro while1 (test &rest body)
  (let ((code '(loop (unless tet (return nil)) . body)))
    (subst test 'test (subst body 'body code))))


(defmacro while2 (test &rest body)
  `(loop (unless ,test (return nil))
         `@body))



(defun find-all (item sequence &rest keyword-args
                                 &key (test #'eql)
                                   test-not
                                   &allow-other-keys)
  (if test-not
      (apply #'remove item sequence
             :test-not (complement test-not) keyword-args)
      (apply #'remove item sequence
             :test (complement test) keyword-args)))

(setf nums '(1 2 3 2 1)) 
(find-all 1 nums :test #'= :key #'abs)


