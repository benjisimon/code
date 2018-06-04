;;
;; The pearson-hashing is responsible for 
;; https://www.google.com/amp/s/programmingpraxis.com/2018/05/25/pearson-hashing/

(import (srfi 27)
        (srfi 151)
        (srfi 69))


(define (%256 x)
  (modulo x 256))

(define (++ x)
  (+ x 1))
(define (-- x)
  (- x 1))

(define (g items key default)
  (cond ((assoc key items) => cdr)
        (else default)))

(define (s++ string)
  (let ((first (car (string->list string)))
        (rest (cdr (string->list string))))
    (list->string (cons (integer->char (%256 (++ (char->integer first))))
                        rest))))

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
    (let loop ((hash 0)
               (chars (map char->integer (string->list text))))
      (cond ((null? chars) hash)
            (else
             (loop (vector-ref (*T*) (bitwise-xor hash (car chars)))
                   (cdr chars))))))
      
;; lr = Larger Range - return back a larger index than 256
(define (lr-pearson-hash text bytes)
  (let loop ((text text)
             (bytes bytes)
             (results '()))
    (cond ((= bytes 0) results)
          (else
           (loop (s++ text) (-- bytes) 
                 (cons (pearson-hash text) results))))))

(define (simple-hash text)
  (let loop ((hash 0)
             (chars (map char->integer (string->list text))))
    (cond ((null? chars) (%256 hash))
          (else
           (loop (+ hash (car chars)) (cdr chars))))))

(define (pearson-hash-mod text)
    (let loop ((hash 0)
               (chars (map char->integer (string->list text))))
      (cond ((null? chars) hash)
            (else
             (loop (vector-ref (*T*) (%256 (+ hash (car chars))))
                   (cdr chars))))))


(define (check-stats results)
  (hash-table-fold results
                   (lambda (key value accum)
                     (let ((smallest (car accum))
                           (biggest (cadr accum)))
                       (list (min smallest value)
                             (max biggest value))))
                   (list 10000 0)))

(define (hash-check hash)
  (for-each (lambda (s)
              (show s '=> (hash s)))
            '("cat" "act" "Cat"))
  (let ((results (make-hash-table)))
    (call-with-input-file "../../../../google-10000-english/google-10000-english.txt"
      (lambda (p)
        (let loop ((line (read-line p)))
          (cond ((eof-object? line)
                 (check-stats results))
                (else
                 (let ((h (hash line)))
                   (hash-table-update!/default results h ++ 0)
                   (loop (read-line p))))))))))
                     
        
