; http://programmingpraxis.com/2014/09/19/diophantine-reciprocals/


; 1/x + 1/y = 1/n
(define (dioph x n)
  (let ((term (- (/ 1 n) (/ 1 x))))
    (if (= (numerator term) 1) (denominator term) #f)))
    
(define (inc x) (+ 1 x))

(define (dioph-gen n init aggregate)
  (let loop ((x (inc n)) (attempt 0) (accum init))
    (if (< attempt n)
        (let ((y (dioph x n)))
          (loop (inc x) (inc attempt)
                (if y (aggregate (cons x y) accum) accum)))
        accum)))
 
 (define (diophs n)
   (dioph-gen n '() cons))
   
 (define (count-diophs n)
   (dioph-gen n 0 (lambda (d a) (inc a))))
    