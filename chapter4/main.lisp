(defun find-all (item sequence &rest keyword-args
                 &key (test #'eql) test-not &allow-other-keys)
  "Find all those elements of sequence that match item,
  according to the keywords.  Doesn't alter sequence."
  (if test-not
      (apply #'remove item sequence
             :test-not (complement test-not) keyword-args)
      (apply #'remove item sequence
             :test (complement test) keyword-args)))

(defvar *dbg-ids* nil "ids used by dbg")

(defun dbg (id format-string &rest args)
  (when (member id *dbg-ids*)
    (apply #'format *debug-io* format-string args)))

(defun debug (&rest ids)
  (setf *dbg-ids* (union ids *dbg-ids*)))

(defun undebug (&rest ids)
  (setf *dbg-ids* (if (null ids)
                      nil
                      (set-difference *dbg-ids* ids))))

(defun dbg-indent (id indent format-string &rest args)
  (when (member id *dbg-ids*)
    (fresh-line *debug-io*)
    (dotimes (i indent)
      (princ " " *debug-io*))
    (apply #'format *debug-io* format-string args)))

(defvar *state* nil "the current state : a list of conditions.")

(defvar *ops* nil "a list of available operators.")

(defstruct op "an operator"
           (action nil)
           (preconds nil)
           (add-list nil)
           (del-list nil))


(defun GPS (*state* goals *ops*)
  "General Problem Solver: achieve all goals using *ops*."
  (when (achieve-all goals) 'solved))

(defun achieve (goal)
  "A goal is achieved if it already holds,
  or if there is an appropriate op for it that is applicable."
  (or (member goal *state*)
      (some #'apply-op
            (find-all goal *ops* :test #'appropriate-p))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if it is in its add list."
  (member goal (op-add-list op)))

(defun apply-op (op)
  "Print a message and update *state* if op is applicable."
  (when (achieve-all (op-preconds op))
    (format t "~%~a" (list 'executing (op-action op)))
    (setf *state* (set-difference *state* (op-del-list op)))
    (setf *state* (union *state* (op-add-list op)))
    t))

(defun achieve-all (goals)
  "try to achieve each goal, then make sure they still hold."
  (and (every #'achieve goals)
       (subsetp goals *state*)))


;; VERSION 2

(defun executing-p (x)
  (starts-with x 'executing))

(defun starts-with (list x)
  (and (consp list)
       (eql (first list) x)))

(defun convert-op (op)
  (unless (some #'executing-p (op-add-list op))
    (push (list 'executing (op-action op))
          (op-add-list op)))
  op)

(defun *ops* nil)

(defun GPS (state goals &optional (*ops* *ops*))
  (remove-if #'atom (achieve-all (cons '(start) state)
                                 goals
                                 nil)))

(defun achieve-all (state goals goal-state)
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (setf current-state
                              (achieve current-state g goal-state)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))

(defun achieve (State goal goal-stack)
  (dbg-indent :gps (length goal-stack) "Goal: ~a" goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op) (apply-op state goal op goal-stack))
                 (find-all goal *ops* :test #'appropriate-p)))))

(defparameter *school-ops*
  (list
   (make-op :action 'drive-son-to-school
            :preconds '(son-at-home car-works)
            :add-list '(son-at-school)
            :del-list '(son-at-home))
   (make-op :action 'shop-installs-battery
            :preconds '(car-needs-battery
                        shop-knows-problem
                        shop-has-money)
            :add-list '(car-works))
   (make-op :action 'tell-shop-problem
            :preconds '(in-communication-with-shop)
            :add-list '(shop-knows-problem))
   (make-op :action 'telephone-shop
            :preconds '(know-phone-number)
            :add-list '(in-communication-with-shop))
   (make-op :action 'look-up-number
            :preconds '(have-phone-book)
            :add-list '(know-phone-number))
   (make-op :action 'give-shop-money
            :preconds '(have-money)
            :add-list '(shop-has-money)
            :del-list '(have-money))))


