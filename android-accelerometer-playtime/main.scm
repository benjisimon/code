;;
;; Tiny scheme program to play around with accelerometer data.
;; I captured this data using the Physics Toolbox Suite app.
;; It's a sweet app that gives you access to recording sensors
;; on your phone.
;;

(load "utils.scm")

;; Use Physics 101 to calculate distance
;; based on the current acceleration, time
;; and velocity
(define (calculate-distance accum data)
  (let* ((t-now (list-ref data 0))
	 (a-now (+
		 (list-ref data 1)  ; ax 
		 (list-ref data 2)  ; ay
		 (list-ref data 3)  ; az
		 ))
	 (t-prev (list-ref accum 0))
	 (v-prev (list-ref accum 1))
	 (d-prev (list-ref accum 2))
	 (t (- t-now t-prev))
	 (v-now (+ v-prev (* a-now t)))
	 (d-now (+ d-prev (* v-now t))))
    (list t-now v-now d-now)))

(define (go)
  (with-data "/sdcard/PhysicsToolboxSuite/4m.5.csv"
	     calculate-distance
	     '(0 0 0)))
		 

			 
