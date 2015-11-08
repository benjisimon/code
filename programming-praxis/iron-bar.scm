;; programming praxis: Iron Bar

(define (dec x)
  (- x 1))
(define (inc x)
  (+ x 1))

(define (ahead? x y)
  (> x y))

(define (behind? x y)
  (<= x y))

(define (make-machine name odds-of-winning)
  (lambda args
    (if (null? args)
	(let ((x (inc (random 100))))
	  (if (<= x odds-of-winning) 'win 'loss))
	(case (car args)
	  ((name) name)))))
	  

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

(define (observe count the-m1 the-m2)
  (let loop ((m1 the-m1) (m2 the-m2) (count count) (offset 0) (dir -1))
    (if (= 0 count)
	(cons (cond ((= 0 offset) '??)
		    ((> offset 0) (the-m2 'name))
		    (else (the-m1 'name)))
	      offset)
      (let ((result (m1)))
	(loop m2 m1
	      (dec count)
	      (+ offset
		 (* (if (eq? result 'win) 1 -1) dir))
	      (* dir -1))))))
		 
(define m1 (make-machine 'm1 100))
(define m2 (make-machine 'm2 10))
(define m3 (make-machine 'm3 13))

(m1 'name)

(play m1 100 100)   ; => 1000
(play m2 100 100)   ; => 80
(play m3 100 100)   ; => 130

(trial 100 m1 100 100)   ; => '(100 . 0)
(trial 1000 m2 100 100)  ; => '(425 . 575)
(trial 1000 m3 100 100)  ; => '(764 . 236)

(observe 100 m1 m2)      ; => '(m1 . -96)
(observe 10 m2 m3)       ; => '(m3 . 4) '(m2 . -2) '(?? . 0)
(observe 100 m2 m3)      ; => '(m3 . 8) '(m2 . -2) '(m3 . 12)
(observe 1000 m2 m3)     ; => '(m3 . 48) '(m3 . 34) '(m3 . 58)
