;;
;; Simulate a slide rule. Not an actual programming praxis exercise, but along the same
;; lines
;;
;; See:
;; http://www.math.utah.edu/~pa/sliderules/
;;

(struct scale (symbol location abs-fn scale-fn) #:prefab)

(define C (scale 'C 'slide
		 (lambda (s)
		   (log s))
		 (lambda (a)
		   (exp a))))

(define D (scale 'D 'body
		 (lambda (s)
		   (log s))
		 (lambda (a)
		   (exp a))))

(define CI (scale 'CI 'slide
		  (lambda (s)
		    (log (/ s (/ 1 s))))
		  (lambda (a)
		    (/ 1 (exp a)))))

(define DI (scale 'CI 'body
		  (lambda (s)
		    (log (/ s (/ 1 s))))
		  (lambda (a)
		    (/ 1 (exp a)))))


(define A (scale 'A 'body
		 (lambda (s)
		   (log (expt s (/ 1 2))))
		 (lambda (a)
		   (expt (exp a) 2))))

(define B (scale 'B 'slide
		 (lambda (s)
		   (log (expt s (/ 1 2))))
		 (lambda (a)
		   (expt (exp a) 2))))

(define R (scale 'R 'slide
		 (lambda (s)
		   (log (expt s 2)))
		 (lambda (a)
		   (sqrt (exp a)))))

(define K (scale 'K 'body
		 (lambda (s)
		   (log (expt s (/ 1 3))))
		 (lambda (a)
		   (expt (exp a) 3))))



(define (make-slide-rule)  
  (let ((offset 0))
    (lambda (action . args)
      (define (align s1 v1 s2 v2)
	(cond ((and (eq? (scale-location s1) 'body)
		    (eq? (scale-location s2) 'slide))
	       (set! offset
		     (- ((scale-abs-fn s1) v1)
			((scale-abs-fn s2) v2)))
	       offset)
	      ((and (eq? (scale-location s1) 'slide)
		    (eq? (scale-location s2) 'body))
	       (align s2 v2 s1 v1))
	      (else
	       (error (format "Must align body to slide, not ~a to ~a"
			      (scale-location s1) (scale-location s2))))))
      (define (read s1 v1 s2)
	(cond ((and (eq? (scale-location s1) 'body)
		    (eq? (scale-location s2) 'slide))
	       ((scale-scale-fn s2) (- ((scale-abs-fn s1) v1) offset)))
	      ((and (eq? (scale-location s1) 'slide)
		    (eq? (scale-location s2) 'body))
	       ((scale-scale-fn s2) (+ ((scale-abs-fn s1) v1) offset)))
	      (else
	       (error (format "Must read from slide to body, or body to slide. Not ~a to ~a"
			      (scale-location s1) (scale-location s2))))))
      (case action
	((align)
	 (apply align args))
	((offset) offset)
	((read)
	 (apply read args))
	(else
	 (error (format "Unknown slide rule command: ~a" action)))))))

(define sr (make-slide-rule))


;; 1 Varible lookups
(sr 'align C 1 D 1)
(sr 'read C 2 A)
(sr 'read C 2 K)
(sr 'read C 2.2 A)
(sr 'read D 4 R)
(sr 'read D 166 R)


;; Basic Multiplication
;; 3 x 5
(sr 'align C 1 D 5)
(sr 'read C 3 D)
;; 2828 x 1.2 = 3393.6
(sr 'align C 1 D 2828)
(sr 'read C 1.2 D)

;; Basic Division
;; 27 / 3
(sr 'align  D 27 C 3)
(sr 'read   C 1 D)
;; 83.383 / 1818 - 0.04586...
(sr 'align  D 83.383 C 1818)
(sr 'read C 1 D)
