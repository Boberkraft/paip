;; The Not Looking after You Don't Leap Problem.
;; Write a program that keeps track of the remaining goals so that it does not get stuck considering only one possible operation when others will eventually lead to the goal.

;; Hint:
;; have achieve take an extra argument indicating the goals that remain to be achieved after the current goal is achieved.
;; achieve should succeed only if it can achieve the current goal and also achieve-all the remaining goals.


(load "4-3.lisp")


(use (push (op 'taxi-son-to-school
               :preconds '(son-at-home have-money)
               :add-list '(son-at-school)
               :del-list '(son-at-home have-money))
           *school-ops*))


(defun achieve (state goal goal-stack other-goals)
  "A goal is achieved if it already holds,
  or if there is an appropriate op for it that is applicable."
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (dbg-indent :gps (length goal-stack) "Goal-stack: ~a" goal-stack)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op)
                     (let ((achieved-state (apply-op state goal op goal-stack)))
                       (if (achieve-all achieved-state other-goals goal-stack)
                           achieved-state)))
                 (appropriate-ops goal state)))))

(defun achieve-each (state goals goal-stack)
  "Achieve each goal, and make sure they still hold at the end."
  (dbg-indent :gps (length goal-stack) "Im in each: ~a" goal-stack)
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (let ((other-goals (remove g goals)))
                          (setf current-state
                                (achieve current-state g goal-stack other-goals))))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))







