;;
;; Implement a version of One Time Pad encryption.
;; Use a trigraph / diana pad method
;; http://danmorgan76.wordpress.com/2013/09/30/encryption-via-a-one-time-pad/
;; http://home.earthlink.net/~specforces/spdiana.htm
;; 

(define (a->i letter)
 (- 65 (char->integer letter)))
  
(define (i->a index)
 (integer->char (+ 65 index)))
 
(define (rand-char)
 (i->a (random-integer 26)))

(define (range low high)
 (if (> low high) '() (cons low (range (+ 1 low) high))))
 
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

            