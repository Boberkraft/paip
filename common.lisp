(defun mappend (fn &rest lsts)
  (apply #'append (apply #'mapcar fn lsts)))

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

(defun start-debug (&rest ids)
  (setf *dbg-ids* (union ids *dbg-ids*)))

(defun stop-debug (&rest ids)
  (setf *dbg-ids* (if (null ids)
                      nil
                      (set-difference *dbg-ids* ids))))

(defun dbg-indent (id indent format-string &rest args)
  (when (member id *dbg-ids*)
    (fresh-line *debug-io*)
    (dotimes (i indent)
      (princ " " *debug-io*))
    (apply #'format *debug-io* format-string args)))
