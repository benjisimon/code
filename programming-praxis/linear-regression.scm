;; https://programmingpraxis.com/2016/06/10/linear-regression/

(define (show . args)
  (for-each (lambda (arg)
	      (display arg)
	      (display " "))
	    args)
  (newline))

(define (as-list x)
  (if (list? x) x (list x)))

(define (g list index)
  (list-ref list index))

(define (make-list n seed)
  (if (= n 0) '()
      (cons seed (make-list (- n 1) seed))))

(define (list->generator lst)
  (let ((remaining lst))
    (lambda ()
      (cond ((null? remaining) '())
	    (else
	     (let ((x (car remaining)))
	       (set! remaining (cdr remaining))
	       x))))))

(define (sigma generator . fns)
  (define (update fns sums data)
    (let loop ((fns fns)
	       (sums sums)
	       (results '()))
      (cond ((null? fns) (reverse results))
	    (else
	     (let ((fn (car fns))
		   (a  (car sums)))
	       (loop (cdr fns)
		     (cdr sums)
		     (cons (+ a (apply fn (as-list data)))
			   results)))))))

    (let loop ((data (generator))
	       (sums (make-list (length fns) 0)))
    (if (null? data) sums
	(loop (generator)
	      (update fns sums data)))))

;; Magic happens here:
;; m = (n × Σxy − Σx × Σy) ÷ (n × Σx2 − (Σx)2)
;; b = (Σy − m × Σx) ÷ n
(define (linear-regression data)
  (let ((sums (sigma data
		      (lambda (x y) (* x y))
		      (lambda (x y) x)
		      (lambda (x y) y)
		      (lambda (x y) (* x x))
		      (lambda (x y) 1))))
    (let* ((Sxy (g sums 0))
	   (Sx  (g sums 1))
	   (Sy  (g sums 2))
	   (Sxx (g sums 3))
	   (n   (g sums 4)))
      (let* ((m (/ (- (* n Sxy) (* Sx Sy))
		   (- (* n Sxx) (* Sx Sx))))
	     (b (/ (- Sy (* m Sx)) n)))
	(cons m b)))))

(define (make-crystal-ball data)
  (let* ((lr (linear-regression data))
	 (m  (car lr))
	 (b  (cdr lr)))
    (lambda (x)
      (+ (* m x) b))))

;; Playtime
(define (test)
  (define data (list->generator '((60   3.1)
				  (61   3.6)
				  (62   3.8)
				  (63   4.0)
				  (65   4.1))))
  (let ((ball (make-crystal-ball data)))
    (show (ball 64))
    (show (ball 66))
    (show (ball 1024))))

