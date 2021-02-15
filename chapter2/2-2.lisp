(load "main-role-based.lisp")

(defun terminalp (category)
  (and (symbolp category)
       (null (assoc category *grammar*))))

(defun categoryp (category)
  (null (terminalp category)))

(defun generate4 (phrase)
  (cond ((listp phrase) (mappend #'generate phrase))
        ((terminalp phrase) (list phrase))
        ((categoryp phrase) (generate (random-elt (rewrites phrase))))))
