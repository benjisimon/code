;; programming praxis: Iron Bar

(define (dec x)
  (- x 1))
(define (inc x)
  (+ x 1))

(define (ahead? x y)
  (> x y))

(define (behind? x y)
  (<= x y))

(define (make-machine odds-of-winning)
  (lambda ()
    (let ((x (inc (random 100))))
      (if (<= x odds-of-winning) 'win 'loss))))

(define (play machine money turns)
  (if (or (= 0 turns) (= 0 money))
      money
      (play machine
	    (+ (dec money)
	       (if (eq? (machine) 'win) 10 0))
	    (dec turns))))

(define (trial count machine money turns)
  (let loop ((count count) (outcome (cons 0 0)))
    (cond ((= 0 count) outcome)
	  (else
	   (let ((result (play machine money turns)))
	     (loop (dec count)
		   (cons
		    (if (ahead? result money) (inc (car outcome)) (car outcome))
		    (if (behind? result money) (inc (cdr outcome)) (cdr outcome)))))))))
  

(define m1 (make-machine 100))
(define m2 (make-machine 10))
(define m3 (make-machine 13))

(play m1 100 100)
(play m2 100 100)

(trial 100 m1 100 100)
(trial 1000 m2 100 100)
(trial 1000 m3 100 100)
