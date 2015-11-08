;;
;; http://programmingpraxis.com/2015/10/02/the-hot-hand/
;;

(define (flip)
  (if (= (random 2) 1) 'H 'T))

(define (sample)
  (list (flip) (flip) (flip) (flip)))

(define (hot? s)
  (cond ((null? s) (void))
	((null? (cdr s)) (void))
	((eq? 'H (car s)) (eq? 'H (cadr s)))
	(else (void))))

(define (collect fn sample)
  (if (null? sample)
      null
      (let ((v (fn sample)))
	(if (void? v)
	    (collect fn (cdr sample))
	    (cons v (collect fn (cdr sample)))))))

(define (only-true items)
  (filter (lambda (t) t) items))

(define (percentify items)
  (if (null? items) 0
      (exact->inexact (/ (length (only-true items))
			 (length items)))))

(define (try count thunk)
  (let loop ((avg (thunk)) (count (- count 1)))
    (if (= 0 count)
	avg
	(loop (/ (+ (thunk) avg) 2) (- count 1)))))

(define (experiment)
  (percentify (collect hot? (sample))))

(try 2000000 experiment)
