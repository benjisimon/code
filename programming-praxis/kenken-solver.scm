;; http://brainwagon.org/2016/05/12/kenken-puzzle-solver/

(define (unique? items)
  (if (null? items)
      #t
      (and (not (member (car items) (cdr items)))
	   (unique? (cdr items)))))

(define (solved? puzzle)
  (not (member '? puzzle)))

(define (blank-puzzle n)
  (make-list n '?))

(define (try sym puzzle)
  (if (null? puzzle)
      (error (format "Whoa, can't try ~a in a blank puzzle" sym))
      (if (eq? (car puzzle) '?)
	  (cons sym (cdr puzzle))
	  (cons (car puzzle)
		(try sym (cdr puzzle))))))

(define (ok? puzzle constraints)
  (if (null? constraints)
      #t
      (let* [(params (map (lambda (i) (list-ref puzzle i))
			  (car (car constraints))))
	     (valid? (if (solved? params)
			 (apply (cdr (car constraints)) params)
			 #t))]
	(and valid? (ok? puzzle (cdr constraints))))))


(define (solve puzzle dictionary constraints)
  (define (go puzzle pool)
    (cond ([solved? puzzle]
	   puzzle)
	  ([null? pool] #f)
	  (else
	   (let [(next-attempt (try (car pool) puzzle))]
	     (if (and (ok? next-attempt constraints)
		      (go next-attempt dictionary))
		 (go next-attempt dictionary)
		 (go puzzle (cdr pool)))))))
  (go puzzle dictionary))
     
(define c
  `(((0 1 2)   . ,(lambda args (unique? args)))
    ((1 2)     . ,(lambda (a b) (= 3 (+ a b))))))
;(solve (blank-puzzle 3) '(0 1 2) c)

(define (uni . args)
  (unique? args))

(define (is op val)
  (lambda args
    (= val (apply op args))))
  

(define kk-6x6-cons
  `(((00 01 02 03 04 05) . ,uni)
    ((06 07 08 09 10 11) . ,uni)
    ((12 13 14 15 16 17) . ,uni)
    ((18 19 20 21 22 23) . ,uni)
    ((24 25 26 27 28 29) . ,uni)
    ((30 31 32 33 34 35) . ,uni)
    ((00 06 12 18 24 30) . ,uni)
    ((01 07 13 19 25 31) . ,uni)
    ((02 08 14 20 26 32) . ,uni)
    ((03 09 15 21 27 33) . ,uni)
    ((04 10 16 22 28 34) . ,uni)
    ((05 11 17 23 29 35) . ,uni)))

(define kk-6x6-dict '(1 2 3 4 5 6))

; (solve (blank-puzzle 36) kk-6x6-dict kk-6x6-cons)

(define kk-p1-cons
  `(((00 01 06) . ,(lambda (a b c) (= 12 (* a b c))))
    ((02 03 04) . ,(lambda (a b c) (= 11 (+ a b c))))
    ((05 11)    . ,(lambda (a b) (= 7 (+ a b))))
    ((07 08)    . ,(lambda (a b) (= 5 (- a b))))
    ((09)       . ,(lambda (a) (= a 9)))
    ((10 14 15 16) . ,(lambda (a b c d) (= 19 (+ a b c d))))
    ((17 23 29) . ,(lambda (a b c) (= 8 (+ a b c))))
    ((28 34 35) . ,(lambda (a b c) (= 72 (* a b c))))
    ((27 33)    . ,(lambda (a b) (= 5 (+ a b))))
    ((32)       . ,(lambda (a) (= a 3)))
    ((30 31)    . ,(lambda (a b) (= 1 (- a b))))
    ((12 18 24 25) . ,(lambda (a b c d) (= 12 (+ a b c d))))
    ((13 19) . ,(lambda (a b) (= 2 (/ a b))))
    ((20 26) . ,(lambda (a b) (= 2 (/ a b))))
    ((21 22) . ,(lambda (a b) (= 5 (- a b))))))

; (solve (blank-puzzle 36) kk-6x6-dict (append kk-p1-cons kk-6x6-cons))

; (solve (blank-puzzle 36) kk-6x6-dict kk-6x6-cons)

(define kk-3x3-cons
  `(((0 1 2) . ,uni)
    ((3 4 5) . ,uni)
    ((6 7 8) . ,uni)
    ((0 3 6) . ,uni)
    ((1 4 7) . ,uni)
    ((2 5 8) . ,uni)))

(define kk-3x3-dict '(1 2 3))

(define kk-p2-cons
  `(((0 1 3) . ,(is * 12))
    ((2) . ,(is + 2))
    ((5 8) . ,(is + 5))
    ((6 7) . ,(is - 2))
    ((4) . ,(is + 1))))

kk-p2-cons

(solve (blank-puzzle 9) kk-3x3-dict (append kk-3x3-cons kk-p2-cons))
