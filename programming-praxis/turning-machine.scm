; A Turning Machine Impl

(define (range lower upper)
 (if (> lower upper) '()
     (cons lower (range (+ 1 lower) upper)))) 

(define tape-padding '#(_ _ _ _ _))

(define (make-tape contents)
 (cons 0 (vector-append (list->vector contents) tape-padding)))

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
  (cond ((< index 0)
         (error "Attempt to move off the left side of the tape: " index))
        ((= index (vector-length (tape-items t)))
         (set-cdr! t (vector-append (tape-items t) tape-padding))))
  (set-car! t index)
  t))

(define (display-tape t)
 (for-each (lambda (i)
            (let ((v (vector-ref (tape-items t) i)))
              (cond ((= i (tape-head t))
                     (display "[")
                     (display v)
                     (display "]"))
                    (else (display v)))
              (display " ")))
           (range 0 (- (vector-length (tape-items t)) 1))))
            
(define (foo)
 (let ((t (make-tape '(a b c))))
  (tape-write t 'x)
  (tape-move t 'R)
  (tape-move t 'R)
  (tape-write t 'y)
  (display-tape t)))