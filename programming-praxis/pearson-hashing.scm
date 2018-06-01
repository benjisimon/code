;;
;; The pearson-hashing is responsible for 
;; https://www.google.com/amp/s/programmingpraxis.com/2018/05/25/pearson-hashing/

(import (srfi 27))

(define (%256 x)
  (modulo x 256))

(define (show . stuff)
  (for-each display stuff)
  (newline))

(define (range lower upper)
  (if (< lower upper)
    (cons lower (range (+ 1 lower) upper))
    '()))

(define (shuffle-vector! v)
  (define (rindex)
    (modulo (random-integer 100000) (vector-length v)))

  (define (rswitch)
    (let* ((i (rindex))
           (j (rindex))
           (a (vector-ref v i))
           (b (vector-ref v j)))
      (vector-set! v i b)
      (vector-set! v j a)))

  (let loop ((i 0))
    (cond ((= i (* (vector-length v) 10))  'done)
          (else
           (rswitch)
           (loop (+ 1 i))))))
  
(define (make-table)
  (let ((v (list->vector (range 0 256))))
    (shuffle-vector! v)
    v))

(define *T* (make-parameter (make-table)))

(define (pearson-hash text)
  (let loop ((hash (%256 (length (string->list text))))
             (chars (map char->integer (string->list text))))
   (cond ((null? chars) hash)
         (else
          (loop (vector-ref (*T*) (%256 (+ hash (car chars))))
                (cdr chars))))))

(define (pearson-check)
  (let ((results  (make-vector 256 0)))
  (call-with-input-file "../../../../google-10000-english/google-10000-english.txt"
    (lambda (p)
      (let loop ((line (read-line p)))
        (cond ((eof-object? line)
               (for-each (lambda (i)
                           (let ((count (vector-ref results i)))
                             (for-each (lambda (j)
                                         (display "."))
                                       (range 0 count))
                             (newline)))
                         (range 0 256)))
              (else
               (let ((h (pearson-hash line)))
                 (vector-set! results h (+ (vector-ref results h) 1))
                 (loop (read-line p))))))))))
                     
        
