; Blum Blum Shub

(define (show . words) 
 (for-each display words))

(define (square x)
 (* x x))

(define (inc x) 
 (+ x 1))
 
(define (tick x M)
 (modulo (square x) M))

(define  (lsb x)
 (bitwise-and x 1))

(define (bbs-seq x M count)
 (let loop ((i 0)
            (x s)
            (accum '()))
  (cond ((= i count) (cons x (map lsb (reverse accum))))
        (else
         (let ((v (tick x M)))
          (loop (inc i)
                v
                (cons v accum)))))))
                
(define (bbs-int x M)
 (let* ((results (bbs-seq x M 8))
        (x (car results))
        (bits (cdr results)))
   

(define (string->integers str)
 (map char->integer (string->list str)))
 
(define (integers->string ints)
 (apply string (map integer->char ints)))

(define (xor-string str generator)
 (integers->string
  (map (lambda (i)
        (bitwise-xor i (generator)))
       (string->integers str))))

(define (const-generator x)
 (lambda ()
  x))

(define (demo-xor str make-generator)
 (let* ((encrypted (xor-string str (make-generator)))
        (decrypted (xor-string encrypted (make-generator))))
  (show "O: " str) (newline)
  (show "E: " encrypted) (newline)
  (show "D: " decrypted) (newline)))
 

; From Wikipedia    
(define (test1 count)
 (bbs-seq 11 19 3 count))
  