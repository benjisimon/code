; http://programmingpraxis.com/2014/09/30/thue-morse-sequence/

(define (flip seq)
  (map (lambda (x) (if (= x 0) 1 0)) seq))
  
 (define (tms terms)
   (let loop ((i 0) (accum '(0)))
     (if (< i terms)
         (loop (+ 1 i)
               (append accum (flip accum)))
         accum)))
         
