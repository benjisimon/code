;;
;; Simulate a slide rule. Not an actual programming praxis exercise, but along the same
;; lines
;;
;; See:
;; http://www.math.utah.edu/~pa/sliderules/
;;

(define (cube-root x)
  (expt x (/ 1 3)))


(define C 'C)
(define D 'D)
(define A 'A)
(define B 'B)
(define K 'K)

(define (scaled->absolute scale x)
  (case scale
    ((C D) (log x))
    ((A B) (log (expt x (/ 1 2))))
    ((K  ) (log (expt x (/ 1 3))))
    (else
     (error (format "Unknown scale: ~a" scale)))))

(define (absolute->scaled scale x)
  (case scale
    ((C D) (exp x))
    ((A B) (expt (exp x) 2))
    ((K  ) (expt (exp x) 3))
    (else
     (error (format "Unknown scale: ~a" scale)))))

(define a->s absolute->scaled)
(define s->a scaled->absolute)


(define (make-slide-rule)
  (let ((offset 0))
    (lambda (action . args)
      (case action
	((align)
	 (let ((s1 (car args))
	       (v1 (cadr args))
	       (s2 (caddr args))
	       (v2 (cadddr args)))
	   (set! offset
		 (- (s->a s1 v1)
		    (s->a s2 v2)))
	   offset))
	((offset) offset)
	((read)
	 (let ((s1 (car args))
	       (v1 (cadr args))
	       (s2 (caddr args)))
	   (a->s s2
		 (+ offset
		    (s->a s1 v1)))))
	(else
	 (error (format "Unknown slide rule command: ~a" action)))))))

(define sr (make-slide-rule))

(sr 'align C 1 D 1)

(sr 'read C 2.2 K)

(sr 'align C 1 D 5)
(sr 'read D 7 C)
  
  

