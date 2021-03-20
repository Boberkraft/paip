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
