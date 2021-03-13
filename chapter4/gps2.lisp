(load "./gps.lisp")


(defun executing-p (x)
  (starts-with x 'executing))

(defun starts-with (list x)
  (and (consp list)
       (eql (first list) x)))


(defun achieve-all (state goals goal-stack)
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (setf current-state
                              (achieve current-state g goal-stack)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))


(defun achieve (state goal goal-stack)
  "A goal is achieved if it already holds,
  or if there is an appropriate op for it that is applicable."
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op) (apply-op state goal op goal-stack))
                 (find-all goal *ops* :test #'appropriate-p)))))

(defun member-equal (item list)
  (member item list :test #'equal))

(defun apply-op (state goal op goal-stack)
  "Return a new, transformed state if op is applicable."
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state (op-preconds op)
                             (cons goal goal-stack))))
    (unless (null state2)
      ;; Return an updated state
      (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
      (append (remove-if #'(lambda (x)
                             (member-equal x (op-del-list op)))
                         state2)
              (op-add-list op)))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if it is in its add-list."
  (member-equal goal (op-add-list op)))

(defun action-p (x)
  (or (equal x '(start))
      (executing-p x)))

(defun GPS (state goals &optional (*ops* *ops*))
  "General Problem Solver: from state, achieve goals using *ops*."
  (remove-if-not #'action-p (achieve-all (cons '(start) state) goals nil)))

(defparameter *banana-ops*
  (list
   (op
    'climb-on-chair
    :preconds '(chair-at-middle-room at-middle-room on-floor)
    :add-list '(at-bananas on-chair)
    :del-list '(at-middle-room on-floor))
   (op 
    'push-chair-from-door-to-middle-room
    :preconds '(chair-at-door at-door)
    :add-list '(chair-at-middle-room at-middle-room)
    :del-list '(chair-at-door at-door))
   (op 
    'walk-from-door-to-middle-room
    :preconds '(at-door on-floor)
    :add-list '(at-middle-room)
    :del-list '(at-door))
   (op 
    'grasp-bananas
    :preconds '(at-bananas empty-handed)
    :add-list '(has-bananas)
    :del-list '(empty-handed))
   (op 
    'drop-ball
    :preconds '(has-ball)
    :add-list '(empty-handed)
    :del-list '(has-ball))
   (op 
    'eat-bananas
    :preconds '(has-bananas)
    :add-list '(empty-handed not-hungry)
    :del-list '(has-bananas hungry))))

