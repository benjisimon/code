;;
;; Implement a version of One Time Pad encryption.
;; Use a trigraph / diana pad method
;; http://danmorgan76.wordpress.com/2013/09/30/encryption-via-a-one-time-pad/
;; http://home.earthlink.net/~specforces/spdiana.htm
;; 

(define (a->i letter)
 (- (char->integer letter) 65))
  
(define (i->a index)
 (integer->char (+ 65 index)))
 
(define (rand-char)
 (i->a (random-integer 26)))

(define (range low high)
 (if (> low high) '() (cons low (range (+ 1 low) high))))
 
(define (head items)
 (let loop ((i 0) (items items) (accum '()))
  (cond ((or (null? items) (= i 5)) (reverse accum))
        (else
         (loop (+ i 1) (cdr items) (cons (car items) accum))))))

(define (tail items)
 (reverse (head (reverse items))))
 

(define (make-pad rows cols)
 (define (make-block)
  (apply string (map (lambda (i) (rand-char)) (range 1 5))))
 (define (make-row)
  (for-each (lambda (i)
             (if (> i 1) (display " ")) 
             (display (make-block)))
            (range 1 cols)))
 (for-each (lambda (i)
             (make-row) (newline))
           (range 1 rows)))

(define (tri-row i)
 (reverse (map (lambda (pos)
                 (i->a (modulo (- pos i) 26)))
          (range 0 25))))

(define (tri-encrypt key plain)
 (let loop ((key (string->list key))
            (plain (string->list plain))
            (coded '()))
  (cond ((null? plain) (apply string (reverse coded)))
        ((equal? #\space (car plain))
         (loop (cdr key) (cdr plain)
               (cons #\space coded)))
        (else
         (let ((row (a->i (car plain)))
               (col (a->i (car key))))
           (loop (cdr key) (cdr plain) 
                 (cons (list-ref (tri-row row) col) coded)))))))          
(define k "ASDFA POUYK")
(define p "HELLO WORLD")
  