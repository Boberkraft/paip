(load "./blocks.lisp")

;; It is possible to implement dbg using a single call to format.
;; Can you figure out the format directives to do this?

(defun dbg-indent (id indent format-string &rest args)
  (when (member id *dbg-ids*)
    (format *debug-io* "~&~vT~?" indent format-string args) ))

