(load "./gps2.lisp")


(defun achieve-all (state goals goal-stack)
  (some #'(lambda (goals)
            (achieve-each state goals goal-stack))
        (orderings goals)))

(defun achieve-each (State goals goal-stack)
  (let ((current-state state))
    (if (and (every (lambda (g)
                      (setf current-state
                            (achieve current-state g goal-stack)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))

(defun orderings (l)
  (if (> (length l) 1)
      (list l (reverse l))
      (list l)))

(defun move-ons (a b c)
  (if (eq b 'table)
      `((,a on ,c))
      `((,a on ,c) (space))))

(defun move-op (a b c)
  (op `(move ,a from ,b to ,c)
      :preconds `((space on ,a)
                  (space on ,b)
                  (,a on ,b))
      :add-list (move-ons a b c)
      :del-list (move-ons a c b)))

(defun make-block-ops (blocks)
  (let ((ops nil))
    (dolist (a blocks)
      (dolist (b blocks)
        (unless (equal a b)
          (dolist (c blocks)
            (unless (or (equal c a)
                        (equal c b))
              (push (move-op a b c)
                    ops)))
          (push (move-op a 'table b)
                ops)
          (push (move-op a b 'table)
                ops))))))