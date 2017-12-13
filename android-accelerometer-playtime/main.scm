;;
;; Tiny scheme program to play around with accelerometer data.
;; I captured this data using the Physics Toolbox Suite app.
;; It's a sweet app that gives you access to recording sensors
;; on your phone.
;;

(load (string-append
       (if (defined? '*src-dir*) *src-dir* "")
       "utils.scm"))



;; Counting the peaks in a given accelerometer stream.  This should
;; give us a rough approximation of jumps
(define (count-peaks accum data)
  (let ((lower 0)
	(upper 10)
	(verbose? #t)
	(a-now (+ (data 1) (data 2) (data 3)))
	(rising? (accum 0))
	(num-peaks (accum 1)))
    (cond ((and rising? (>= a-now upper))
	   (if verbose?
	       (show "peak discovered: " a-now))
	   (list #f (+ 1 num-peaks)))
	  ((and (not rising?) (<= a-now lower))
	   (list #t num-peaks))
	  (else
	   (list rising? num-peaks)))))


;; Use Physics 101 to calculate distance
;; based on the current acceleration, time
;; and velocity
(define (calculate-distance accum data)
  (let* ((t-now (data 0))
	 (a-now (+
		 (data 1)  ; ax 
		 (data 2)  ; ay
		 (data 3)  ; az
		 ))
	 (t-prev (accum 0))
	 (v-prev (accum 1))
	 (d-prev (accum 2))
	 (t (- t-now t-prev))
	 (v-now (+ v-prev (* a-now t)))
	 (d-now (+ d-prev (* v-now t))))
    (list t-now v-now d-now)))

(define (count-jumps path)
  (cadr (with-data path count-peaks '(#t 0))))


		 

			 
