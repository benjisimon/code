; Blum Blum Shub

(define (show . words) 
 (for-each display words))

(define (showln . words)
 (apply show words)
 (newline))

(define (zero? x)
 (= x 0))

(define (square x)
 (* x x))

(define (inc x) 
 (+ x 1))
(define (dec x)
 (- x 1))

(define  (lsb x)
 (bitwise-and x 1))

(define (take n generator)
 (if (> n 0)
     (cons (generator) (take (dec n) generator))
     '()))

(define (range lower upper)
 (if (>= lower upper)
     '()
     (cons lower (range (inc lower) upper))))

(define (bbs-values p q s)
 (let ((x s)
       (M (* p q)))
  (lambda ()
    (let ((x1 (modulo (square x) M)))
     (set! x x1)
     x1))))

(define (bbs-bits p q s)
 (let ((gen (bbs-values p q s)))
  (lambda ()
   (lsb (gen)))))
   
(define (bbs-numbers p q s)
 (let ((gen (bbs-bits p q s)))
  (lambda ()
   (let loop ((i 0) (num 0))
    (cond ((= i 26) num)
          (else
           (loop (inc i)
                 (bitwise-ior num
                              (arithmetic-shift (gen) i)))))))))

(define (bbs-chars p q s)
 (let ((gen (bbs-numbers p q s)))
  (lambda ()
   (let ((n (gen)))
    (integer->char (+ 65 (modulo n 26)))))))

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

(define char-gen (bbs-chars 11 19 3))

(define (make-pad rows blocks gen)
 (for-each (lambda (row)
            (for-each (lambda (block)
                       (show (apply string (take 4 gen)) " "))
                      (range 0 blocks))
            (newline))
           (range 0 rows)))

; From Wikipedia    
(define (test1)
 (showln (take 6 (bbs-values 11 19 3)))
 (showln (take 6 (bbs-bits 11 19 3)))
 (showln (take 6 (bbs-numbers 11 19 3)))
 (showln (take 6 (bbs-chars 11 19 3))))
 
 
(define (test2)
 (let ((gen (bbs-bits 11 19 3)))
   (let loop ((index 100000) (ones 0) (zeros 0))
    (cond ((= index 0)
           (showln "1's = " ones)
           (showln "0's = " zeros))
          (else
           (let ((next (gen)))
            (loop (dec index)
                  (+ ones (if (zero? next) 0 1))
                  (+ zeros (if (zero? next) 1 0)))))))))
                        
            
  