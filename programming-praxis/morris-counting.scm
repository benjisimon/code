;;
;; http://programmingpraxis.com/2015/02/20/morris-counting/
;;

(define (show . words)
 (for-each display words)
 (newline))

(define (heads? n)
 (let ((flip (= 1 (random-integer 2))))
  (cond ((not flip) #f)
        ((and flip (= n 1)) #t)
        (else (heads? (- n 1))))))
        
(define (int-count n)
 (+ 1 n))
 
(define (morris-count c)
 (cond ((= c 0) 1)
       ((heads? c) (int-count c))
       (else c)))
       
(define (morris-value c)
 (- (expt 2 c) 1))
  
(define (trial upper)
 (let loop ((n (random-integer upper))
            (i 0)
            (c 0))
  (cond ((= n 0)
         (show "actual=" i ", morris=" (morris-value c)))
        (else
         (loop (- n 1)
               (int-count i)
               (morris-count c))))))
               
(define (test)
 (for-each trial '(10 50 100 200 500 800 1000 1500 2000 5000 7000 10000)))

