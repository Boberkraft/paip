;; (Exercise in altering structure.)
;; Write a program that will play the role of the guesser in the game Twenty Questions.
;; The user of the program will have in mind any type of thing.
;; The program will ask questions of the user, which must be answered yes or no, or "it" when the program has guessed it.
;; If the program runs out of guesses, it gives up and asks the user what "it" was.
;; At first the program will not play well, but each time it plays, it will remember the user's replies and use them for subsequent guesses.



(defstruct question
  query
  (next-for-yes nil)
  (next-for-no nil))

(defparameter *question* (make-question :query "lol"))


(defun play ()
  (format t "Welcome! Lets play!")
  (play-loop *question*))


(defun play-loop (question)
  (format t "~%Type 'it' if quessed")
  (format t "~%or yes/no to give clue.~%")
  (format t "Is it a ~%~a?" (question-query question))
  (case (read)
    (it (format t "Whoohoo!"))
    (yes (if (question-next-for-yes question)
             (play-loop (question-next-for-yes question))
             (setf (question-next-for-yes question) (play-loop-ask-for-new))))
    (no (if (question-next-for-no question)
            (play-loop (question-next-for-no question))
            (setf (question-next-for-no question) (play-loop-ask-for-new))))
    (otherwise
     (format t "I don't understand...")
     (play-loop question))))

(defun play-loop-ask-for-new ()
  (format t "~%Sorry, but i lost :(")
  (format t "~%Can you tell me what it was?")
  (make-question :query (read-line)))

(play)
