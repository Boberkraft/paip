(load "blocks.lisp")

;; GPS does not recognize the situation where a goal is accidentally solved as part of achieving another goal. Consider the goal of eating dessert. Assume that there are two operators available: eating ice cream (which requires having the ice cream) and eating cake (which requires having the cake). Assume that we can buy a cake, and that the bakery has a deal where it gives out free ice cream to each customer who purchases and eats a cake.
;; (1) Design a list of operators to represent this situation.
;; (2) Give gps the goal of eating dessert. Show that, with the right list of operators, gps will decide to eat ice cream, then decide to buy and eat the cake in order to get the free ice cream, and then go ahead and eat the ice cream, even though the goal of eating dessert has already been achieved by eating the cake.
;; (3) Fix gps so that it does not manifest this problem.

;; The following exercises address the problems in version 2 of the program.

;; (1)
(use (list
      (op '(get cake from bakery)
          :add-list '((cake)))
      (op '(eat ice cream)
          :add-list '((executing (eat dessert)))
          :preconds '((ice cream))
          :del-list '((ice cream)))
      (op '(eat cake for free ice cream)
          :add-list '((ice cream) (executing (eat dessert)))
          :preconds '((cake))
          :del-list '((cake)))))

;; (2)
(gps nil '((executing (eat dessert))))
#+ nil ((START)
        (EXECUTING (GET CAKE FROM BAKERY))
        (EXECUTING (EAT DESSERT))
        (EXECUTING (EAT DESSERT)))

;; because this seems a little bit bugged, i made second mission where the goal is to get stuffed

;; (1)

(use (list
      (op '(eat ice cream)
          :add-list '((stuffed))
          :preconds '((ice cream))
          :del-list '((ice cream)))
      (op '(buy cake)
          :add-list '((cake)))
      (op '(eat cake)
          :add-list '((stuffed) (ice cream))
          :preconds '((cake))
          :del-list '((cake)))
      ))

;; when first is swaped with last, the problem is 'fixed'

;; (2)
(gps nil '((stuffed)))

#+nil ((Start)
       (EXECUTING (BUY CAKE))
       (EXECUTING (EAT CAKE))
       (EXECUTING (EAT ICE CREAM)))


;; (3)

(defun achievedp (state goal)
  (member-equal goal state))

(defun apply-op (state goal op goal-stack)
  "Return a new, transformed state if op is applicable."
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state
                             (op-preconds op)
                             (cons goal goal-stack))))
    (when state2
      ;; Return an updated state
      (if (achievedp state2 goal)
          (progn
            (dbg-indent :gps (length goal-stack) "It seeams that goal (~a) is already achieved" goal)
            state2)
          (progn
            (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
            (append (remove-if #'(lambda (x)
                                   (member-equal x (op-del-list op)))
                               state2)
                    (op-add-list op)))
          ))))

#+ nil ((START)
        (EXECUTING (BUY CAKE))
        (EXECUTING (EAT CAKE)))
