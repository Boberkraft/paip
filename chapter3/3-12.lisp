;; Write a single expression using format that will take a list of words and print them as a sentence, with the first word capitalized and a period after the last word. You will have to consult a reference to learn new format directives.


(setf words '("hello" "my" "friend"))

(format t "~%~@(~{~a~^ ~}~)." words)
