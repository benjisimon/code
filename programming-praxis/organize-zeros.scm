; Programming Praxis exercise: ???
; (It's the facebook one where you need to move all zeros to
; the start of a vector, and all non-zeros to the end)

(define s (vector 3 0 5 9 2 0 0 1 8))

(define (g vec index)
 (vector-ref vec index))
 
(define (zero? x)
 (= x 0))
(define (nzero? x)
 (not (zero? x)))
 
(define (vswap vec i j)
 (let ((new-j (g vec i))
       (new-i (g vec j)))
  (vector-set! vec i new-i)
  (vector-set! vec j new-j)
  vec))

(define (inc x)
 (+ x 1))
(define (dec x)
 (- x 1))
(define (do-if vec op index pred?)
 (if (pred? (g vec index)) (op index) index))
 
(define (show . args)
 (for-each (lambda (a) (write a) (display " ")) args)
 (newline))

(define (organize vec)
 (let loop ((non-zero-ptr 0)
            (zero-ptr (dec (vector-length vec))))
  (show non-zero-ptr zero-ptr vec)
  (cond ((>= non-zero-ptr zero-ptr) vec)
        ((and (nzero? (g vec non-zero-ptr))
              (zero? (g vec zero-ptr)))
         (vswap vec non-zero-ptr zero-ptr)
         (loop (inc non-zero-ptr) (dec zero-ptr)))
        (else
         (loop (do-if vec inc non-zero-ptr zero?)
               (do-if vec dec zero-ptr nzero?))))))
