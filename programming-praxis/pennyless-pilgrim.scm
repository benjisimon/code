;; http://thekidshouldseethis.com/post/can-you-solve-the-penniless-pilgrim-riddle

(define (show . x)
  (for-each display x)
  (newline))

(define (++ x) (+ 1 x))
(define (-- x) (- x 1))

(define (street-name x0 y0 x1 y1)
  (apply string-append
         (if (or (and (< x0 x1) (= y0 y1))
                 (and (< y0 y1) (= x0 x1)))
           (list (number->string x0)
                 ","
                 (number->string y0)
                 "-"
                 (number->string x1)
                 ","
                 (number->string y1))
           (list (number->string x1)
                 ","
                 (number->string y1)
                 "-"
                 (number->string x0)
                 ","
                 (number->string y0)))))


(define (next-x x direction)
  (case direction
    ((east) (-- x))
    ((west) (++ x))
    (else x)))  

(define (next-y y direction)
  (case direction
    ((north) (++ y))
    ((south) (-- y))
    (else y)))

(define (next-street x y direction)
  (street-name x y 
               (next-x x direction)
               (next-y y direction)))1

(define (visited? x y direction history)
    (member (next-street x y direction) history))
        
(define (can-walk-north? x y history)
  (and (< y 4)
       (not (visited? x y 'north history))))

(define (can-walk-south? x y history)
  (and (> y 0)
       (not (visited? x y 'south history))))

(define (can-walk-west? x y history)
  (and (< x 4)
       (not (visited? x y 'west history))))

(define (can-walk-east? x y history)
  (and (> x 0)
       (not (visited? x y 'east history))))

(define (arrived? x y)
  (and (= x 0) (= y 0)))

(define (try direction x y owed walked)
  (solve (next-x x direction)
         (next-y y direction)
         (case direction
           ((south) (* owed 2))
           ((north) (/ owed 2))
           ((east) (+ owed 2))
           ((west) (- owed 2)))
         (cons (next-street x y direction)
               walked)))
               

(define (solve x y owed walked)
  (show (list x y owed (length walked)))
  (cond ((arrived? x y) (list (= owed 0) owed walked))
        (else
         (let loop ((options
                     (apply 
                      append
                      (list
                       (if (can-walk-north? x y walked) '(north) '())
                       (if (can-walk-south? x y walked) '(south) '())
                       (if (can-walk-east? x y walked) '(east) '())
                       (if (can-walk-west? x y walked) '(west) '())))))
           (cond ((null? options)
                  (list #f owed walked))
                 (else
                  (let ((attempt (try (car options) x y owed walked)))
                    (if (car attempt)
                      attempt
                      (loop (cdr options))))))))))
           
    



