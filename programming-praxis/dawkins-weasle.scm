; http://programmingpraxis.com/2014/11/14/dawkins-weasel/
(define goal (string->list "METHINKS IT IS LIKE A WEASEL"))

(define (range low high)
 (if (> low high) '()
     (cons low (range (+ 1 low) high))))

(define (rand-char)
 (let ((offset (random-integer 27)))
  (if (= offset 26) #\space
      (integer->char (+ 65 offset)))))
      
(define (mutate input)
 (map (lambda (x)
       (let ((rand (random-integer 100)))
        (if (< rand 5) (rand-char) x)))
       input))
  
(define (score input)
 (let loop ((value 0) (input input) (goal goal))
  (cond ((null? input) value)
        (else
         (loop (if (equal? (car input) (car goal))
                   (+ 1 value) 0)
               (cdr input) (cdr goal))))))
               
(define (bang)
 (map (lambda (c) (rand-char)) goal))
 

(define (tick input)
 (let ((attempts
         (sort (map (lambda (i) (mutate input)) (range 1 100))
               (lambda (x y)
                 (> (score x) (score y))))))
   (car attempts)))
 
(define (solve)
 (let loop ((generation 0) (input (bang)))
  (cond ((equal? goal input) generation)
        (else
         (display (list generation (score input))) (newline)
         (loop (+ 1 generation)
               (tick input))))))
  
   



   
;;;============================================================================

;;; File: "Sort.scm", Time-stamp: <2008-03-18 15:21:35 feeley>

;;; Copyright (c) 2006-2008 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; (sort sequence less?) sorts a sequence (a list or vector) in a
;;; non-destructive way ordered using the comparison predicate less?.
;;;
;;; Sample use:
;;;
;;;  (sort (vector 3 1 4 1 5) >) => #(5 4 3 1 1)

;;;============================================================================

(define (sort sequence less?)

  (declare (standard-bindings) (not safe))

  (define (sort-list lst less?)

    (define (mergesort lst)

      (define (merge lst1 lst2)
        (cond ((not (pair? lst1))
               lst2)
              ((not (pair? lst2))
               lst1)
              (else
               (let ((e1 (car lst1)) (e2 (car lst2)))
                 (if (less? e1 e2)
                     (cons e1 (merge (cdr lst1) lst2))
                     (cons e2 (merge lst1 (cdr lst2))))))))

      (define (split lst)
        (if (or (not (pair? lst)) (not (pair? (cdr lst))))
            lst
            (cons (car lst) (split (cddr lst)))))

      (if (or (not (pair? lst)) (not (pair? (cdr lst))))
          lst
          (let* ((lst1 (mergesort (split lst)))
                 (lst2 (mergesort (split (cdr lst)))))
            (merge lst1 lst2))))

    (mergesort lst))

  (cond ((not (procedure? less?))
         (error "procedure expected"))
        ((or (null? sequence)
             (pair? sequence))
         (sort-list sequence less?))
        ((vector? sequence)
         (list->vector (sort-list (vector->list sequence) less?)))
        (else
         (error "vector or list expected"))))

;;;============================================================================
