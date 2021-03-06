(load "./gps.lisp")


(defun executing-p (x)
  (starts-with x 'executing))

(defun starts-with (list x)
  (and (consp list)
       (eql (first list) x)))
(defun achieve (State goal goal-stack)
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op) (apply-op state goal op goal-stack))
                 (find-all goal *ops* :test #'appropriate-p)))))

(defun achieve-all (state goals goal-stack)
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (setf current-state
                              (achieve current-state g goal-stack)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))


(defun member-equal (item list)
  (member item list :test #'equal))

(defun apply-op (state goal op goal-stack)
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state (op-preconds op)
                             (cons goal goal-stack))))
    (unless (null state2)
      (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
      (append (remove-if #'(lambda (x)
                             (member-equal x (op-del-list op)))
                         state2)
              (op-add-list op)))))

(defun GPS (state goals &optional (*ops* *ops*))
  (remove-if #'atom (achieve-all (cons '(start) state)
                                 goals
                                 nil)))

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


