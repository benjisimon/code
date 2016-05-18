;; http://brainwagon.org/2016/05/12/kenken-puzzle-solver/

(define (show . words)
  (for-each (lambda (w)
	      (display w)
	      (display " "))
	    words)
  (newline))

(define (unique? items)
  (if (null? items)
      #t
      (and (not (member (car items) (cdr items)))
	   (unique? (cdr items)))))

(define (solved? puzzle)
  (not (member '? puzzle)))

(define (blank-puzzle n)
  (if (= 0 n)
      '()
      (cons '? (blank-puzzle (- n 1)))))

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
      (let* ((params (map (lambda (i) (list-ref puzzle i))
			  (car (car constraints))))
	     (valid? (if (solved? params)
			 (apply (cdr (car constraints)) params)
			 #t)))
	(and valid? (ok? puzzle (cdr constraints))))))


(define (solve puzzle dictionary constraints)
  (define (go puzzle pool)
    (cond ((solved? puzzle)
	   puzzle)
	  ((null? pool) #f)
	  (else
	   (let* ((next-attempt (try (car pool) puzzle))
		  (valid (and (ok? next-attempt constraints)
			      (go next-attempt dictionary))))
	     (if valid
		 valid
		 (begin
		   ;; (show "Rejecting:" next-attempt)
		   (go puzzle (cdr pool))))))))
  (go puzzle dictionary))

(define (uni . args)
  (unique? args))

(define (is op val)
  (lambda args
    (if (memq op (list / -))
	(or (= val (apply op args))
	    (= val (apply op (reverse args))))
	(= val (apply op args)))))
  
  

(define kk-3x3-cons
  `(((0 1 2) . ,uni)
    ((3 4 5) . ,uni)
    ((6 7 8) . ,uni)
    ((0 3 6) . ,uni)
    ((1 4 7) . ,uni)
    ((2 5 8) . ,uni)))

(define kk-3x3-dict '(1 2 3))

(define kk-p1-cons
  `(((0 3) . ,(is + 3))
    ((2 5 4) . ,(is + 8))
    ((7 8) . ,(is + 3))
    ((6) . ,(is + 3))
    ((1) . ,(is + 1))))

;; (solve (blank-puzzle 9) kk-3x3-dict (append kk-3x3-cons kk-p1-cons))

(define kk-p2-cons
  `(((0 1) . ,(is + 3))
    ((2 5) . ,(is + 5))
    ((7 8) . ,(is + 4))
    ((3 6) . ,(is + 5))
    ((4)   . ,(is + 1))))

;; (solve (blank-puzzle 9) kk-3x3-dict (append kk-3x3-cons kk-p2-cons))

(define kk-4x4-cons
  `(((0 1 2 3) . ,uni)
    ((4 5 6 7) . ,uni)
    ((8 9 10 11) . ,uni)
    ((12 13 14 15) . ,uni)
    ((0 4 8 12) . ,uni)
    ((1 5 9 13) . ,uni)
    ((2 6 10 14) . ,uni)
    ((3 7 11 15) . ,uni)))

(define kk-4x4-dict '(1 2 3 4))

(define kk-p3-cons
  `(((0 1) . ,(is + 6))
    ((2 3 7) . ,(is * 12))
    ((6 10 11) . ,(is * 4))
    ((5 9) . ,(is + 4))
    ((4) . ,(is + 3))
    ((8 12) . ,(is - 3))
    ((13 14) . ,(is / 2))
    ((15) . ,(is + 3))))

;; (solve (blank-puzzle 16) kk-4x4-dict (append kk-4x4-cons kk-p3-cons))

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

(define kk-p4-cons
  `(((0 1 6) . ,(is * 12))
    ((2 3 4) . ,(is + 11))
    ((5 11)    . ,(is + 7))
    ((17 23 29) . ,(is + 8))
    ((28 34 35) . ,(is * 72))
    ((27 33) . ,(is + 5))
    ((32) . ,(is + 3))
    ((30 31) . ,(is - 1))
    ((12 18 24 25) . ,(is + 12))
    ((13 19) . ,(is / 2))
    ((20 26) . ,(is / 2))
    ((14 15 16 10) . ,(is + 19))
    ((9) . ,(is + 3))
    ((7 8) . ,(is - 5))
    ((21 22) . ,(is - 5))))

;; (solve (blank-puzzle 36) kk-6x6-dict (append kk-6x6-cons kk-p4-cons))

