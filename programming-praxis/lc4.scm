;; http://programmingpraxis.com/2018/03/27/elsie-four/

(import (srfi 27)
        (srfi 1))

(define (show . x)
  (display x)
  (newline))

(define (div x y) (quotient x y))
(define (mod x y) (remainder x y))
(define (mod6 x) (mod x 6))
(define (div6 x) (div x 6))

(define *alphabet*  (string->list "#_23456789abcdefghijklmnopqrstuvwxyz"))

(define (n->c n)
  (list-ref *alphabet* n))

(define (c->n c)
  (let loop ((i 0) (left *alphabet*))
    (cond ((null? left) 
           (error "D'oh, looks like this isn't a valid character " c))
          ((equal? (car left) c) i)
          (else
           (loop (+ 1 i) (cdr left))))))

(define (pluck list index)
  (let ((left (take list index))
        (right (drop list (+ index 1))))
    (append left right)))
        

(define (shuffle items)
  (let loop ((src items) (dest '()))
    (cond ((null? src) dest)
          (else
           (let ((index (random-integer (length src))))
             (loop (pluck src index)
                   (cons (list-ref src index) dest)))))))

(define (range low high)
   (if (< low high)
     (cons low (range (+ 1 low) high))
     '()))


(define (index-of state char)
  (let ((needle (c->n char)))
    (let loop ((i 0)
               (remaining state))
      (cond ((null? remaining) (error "char not found " state char))
            ((= needle (car remaining)) i)
            (else
             (loop (+ i 1) (cdr remaining)))))))

(define (row-of state char)
  (div6 (index-of state char)))

(define (col-of state char)
  (mod6 (index-of state char)))

(define (val-at state r c)
  (list-ref state (+ (* r 6) c)))

(define (make-key)
  (shuffle (range 0 36)))

(define (show-state state)
  (let loop ((remaining state))
    (cond ((not (null? remaining))
           (apply show (map n->c (take remaining 6)))
           (loop (drop remaining 6))))))
             

(define (right-rotate-row state r)
  state)

(define (down-rotate-col state r)
  state)

(define (tick S i j P)
  (let* ((r (row-of S P))
         (c (col-of S P))
         (x (mod6 (+ r (div6 (val-at S i j)))))
         (y (mod6 (+ c (mod6 (val-at S i j)))))
         (C (val-at S x y)))
    (values (down-rotate-col 
             (right-rotate-row S r) c)
            (mod6 (+ i (div6 C)))
            (mod6 (+ j (mod6 C)))
            (n->c C))))
          
    
    
