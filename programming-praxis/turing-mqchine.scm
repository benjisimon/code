; A Turning Machine Impl
; Inspired by:
;  http://aturingmachine.com/examplesSyntax.php

(define (range lower upper)
 (if (>= lower upper) '()
     (cons lower (range (+ 1 lower) upper)))) 

(define (show . words)
 (for-each display words))

(define tape-blank '#(_))

(define (make-tape contents)
 (cons 0 (vector-append (list->vector contents) tape-blank)))

(define (tape-head t)
 (car t)) 
(define (tape-items t)
 (cdr t))
 
(define (tape-read t)
 (vector-ref (tape-items t) (tape-head t)))
 
(define (tape-write t x)
 (vector-set! (tape-items t) (tape-head t) x)
 t)
 
(define (tape-move t direction)
 (let ((index (+ (tape-head t)
                 (case direction
                  ((< L) -1)
                  ((> R) 1)
                  ((- N) 0)
                  (else (error "Unknown tape movement: " direction))))))
  (cond ((= index -1)
         (set-cdr! t (vector-append tape-blank (tape-items t)))
         (set! index 0))
        ((= index (vector-length (tape-items t)))
         (set-cdr! t (vector-append (tape-items t) tape-blank))))
  (set-car! t index)
  t))

(define (display-tape t)
 (for-each (lambda (i)
            (let ((v (vector-ref (tape-items t) i)))
              (cond ((= i (tape-head t))
                     (show "[" v "]"))
                    (else (show v)))
              (show " ")))
           (range 0 (vector-length (tape-items t)))))

(define (tm-find state tape rules)
 (let ((needle (list state (tape-read tape))))
  (let loop ((rules rules))
   (cond ((null? rules) #f)
         ((equal? needle (caar rules)) (cadar rules))
         (else
          (loop (cdr rules))))))) 
            
(define (make-tm initial-state initial-tape halting-states rules)
 (let ((state initial-state)
       (tape (make-tape initial-tape)))
 (lambda (cycles)
  (let loop ((cycle 0))
   (show state ": ")
   (display-tape tape)
   (newline)
   (cond ((= cycle cycles) #t)
         ((member state halting-states) state)
         ((tm-find state tape rules) =>
          (lambda (dest)
           (let* ((new-state (car dest))
                  (new-symbol (cadr dest))
                  (new-direction (caddr dest)))
             (set! state new-state)
             (tape-write tape new-symbol)
             (tape-move tape new-direction)
             (loop (+ 1 cycle)))))
          (else 'no-matching-rules))))))

; Binary Counting - http://aturingmachine.com/examples.php
(define r0 '(((walk  0) (walk  0 >))
             ((walk  1) (walk  1 >))
             ((walk  _) (count _ <))
             ((count 0) (walk  1 >))
             ((count 1) (count 0 <))
             ((count _) (walk  1 >))))
             
(define tm0 (make-tm 'walk '(0) '() r0))

; Turning's First Example 
;  http://en.m.wikipedia.org/wiki/Turing_machine_examples
(define r1 '(((b _) (c 0 >))
             ((c _) (e _ >))
             ((e _) (f 1 >))
             ((f _) (b _ >))))
             
(define tm1 (make-tm 'b '() '() r1))

; http://programmingpraxis.com/2009/3/27/a-turing-machine-simulator/

(define r2 '(((0 1) (0 1 R))
             ((0 +) (1 1 R))
             ((1 1) (1 1 R))
             ((1 _) (2 _ L))
             ((2 1) (H 1 N))))

(define tm2
 (make-tm 0
         '(1 1 1 + 1 1 1 1)
         '(H)
         r2))
         
