; Blum Blum Shub

(define (square x)
 (* x x))

(define (inc x) 
 (+ x 1))
 
(define (tick x M)
 (modulo (square x) M))

(define  (lsb x)
 (if (= (modulo x 2) 0)
     0 1))
     
(define (bbs p q s count)
 (let loop ((i 0)
            (M (* p q))
            (x s)
            (accum '()))
  (cond ((= i count) (reverse accum))
        (else
         (let ((v (tick x M)))
          (loop (inc i)
                M v
                (cons v accum)))))))

; From Wikipedia    
(define (test count)
 (bbs 11 19 3 count))
  