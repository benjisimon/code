;; http://programmingpraxis.com/2018/03/27/elsie-four/

(import (srfi 27)
        (srfi 1))
55
(define (show . x)
  (display x)
  (newline))

(define (div x y) (quotient x y))
(define (mod x y) (remainder x y))
(define (mod6 x) (mod x 6))
(define (div6 x) (div x 6))
(define (++ x) (+ x 1))
(define (-- x) (- x 1))
(define (++% x) (mod6 (++ x)))

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

(define (string->key text)
  (map c->n 
       (filter (lambda (x)
                 (not (equal? x #\space)))
               (string->list text))))
  
(define (show-state state)
  (let loop ((remaining state))
    (cond ((not (null? remaining))
           (display (list->string (map n->c (take remaining 6))))
           (display " ")
           (loop (drop remaining 6)))))
  (newline))
             

(define (right-rotate-row state r)
  (let* ((start (* 6 r))
         (end   (+ start 6))) 
    (let loop ((i 0)
               (updated '()))
      (cond ((= i (length state)) (reverse updated))
            (else
             (cond ((or (< i start)
                        (>= i end))
                    (loop (++ i) (cons (list-ref state i) updated)))
                   ((= i start)
                    (loop (++ i) (cons (list-ref state (+ i 5)) updated)))
                   (else
                    (loop (++ i) (cons (list-ref state (-- i))
                                       updated)))))))))
             
(define (down-rotate-col state c)
  (let loop ((i 0) (updated '()))
    (cond ((= i (length state)) 
           (reverse updated))
          ((= i c) 
           (loop (++ i)
                 (cons (list-ref state (+ 30 c))
                       updated)))
          ((= (mod6 i) c)
           (loop (++ i)
                 (cons (list-ref state (- i 6))
                       updated)))
          (else
           (loop (++ i) 
                 (cons (list-ref state i)
                       updated))))))

(define (e-tick S i j P)
  (show-state S)
  (show i j P)
  (let* ((r (row-of S P))
         (c (col-of S P))
         (x (mod6 (+ r (div6 (val-at S i j)))))
         (y (mod6 (+ c (mod6 (val-at S i j)))))
         (C (val-at S x y)))
    (let* ((S1 (right-rotate-row S r))
           (c (++% c))
           (y (if (= x r) (++% y) y))
           (r (if (= i r) (++% r) r)))
      (let* ((S2 (down-rotate-col S1 y))
             (x (++% x))
             (r (if (= c y) (++% r) r))
             (i (if (= j y) (++% i) i)))
        (values S2 
                (mod6 (+ i (div6 C)))
                (mod6 (+ j (mod6 C)))
                (n->c C))))))

(define (encrypt key text)
  (let loop ((S key)
             (i 0)
             (j 0)
             (plain (string->list text))
             (coded '()))
    (cond ((null? plain) (list->string (reverse coded)))
          (else
           (let-values (((S i j C) (e-tick S i j (car plain)))) 
             (loop S i j (cdr plain) (cons C coded)))))))
    
                 
(define sample-key
  (string->key "xv7ydq #opaj_ 39rzut 8b45wc sgehmi knf26l"))

(encrypt sample-key "solwbf")
