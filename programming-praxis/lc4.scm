;; http://programmingpraxis.com/2018/03/27/elsie-four/

(import (srfi 27)
        (srfi 1))

(define *alphabet*  (string->list "#_23456789abcdefghijklmnopqrstuvwxyz"))


(define (key-size)
  (length *alphabet*))

(define (block-size)
  (sqrt (length *alphabet*)))

(define bs block-size)

(define (show . x)
  (display x)
  (newline))

(define (say . x)
  (for-each (lambda (y) (display y) (display " "))
            x)
  (newline))

(define (div x y) (quotient x y))
(define (mod x y) (remainder x y))
(define (% x) 
  (let* ((z (mod x (bs))))
    (if (< z 0) (+ (bs) z)  z)))
(define ($ x) (div x (sqrt (length *alphabet*))))
(define (++ x) (+ x 1))
(define (-- x) (- x 1))
(define (++% x) (% (++ x)))

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
  ($ (index-of state char)))

(define (col-of state char)
  (% (index-of state char)))

(define (val-at state r c)
  (list-ref state (+ (* r (bs)) c)))

(define (make-key)
  (shuffle (range 0 (key-size))))

(define (string->key text)
  (map c->n 
       (filter (lambda (x)
                 (not (equal? x #\space)))
               (string->list text))))
  
(define (show-state state)
  (let loop ((remaining state))
    (cond ((not (null? remaining))
           (display (list->string (map n->c (take remaining (bs)))))
           (display " ")
           (loop (drop remaining (bs))))))
  (newline))
             

(define (right-rotate-row state r)
  (let* ((start (* (bs) r))
         (end   (+ start (bs)))) 
    (let loop ((i 0)
               (updated '()))
      (cond ((= i (length state)) (reverse updated))
            (else
             (cond ((or (< i start)
                        (>= i end))
                    (loop (++ i) (cons (list-ref state i) updated)))
                   ((= i start)
                    (loop (++ i) (cons (list-ref state (+ i (-- (bs)))) updated)))
                   (else
                    (loop (++ i) (cons (list-ref state (-- i))
                                       updated)))))))))
             
(define (down-rotate-col state c)
  (let loop ((i 0) (updated '()))
    (cond ((= i (length state)) 
           (reverse updated))
          ((= i c) 
           (loop (++ i)
                 (cons (list-ref state (+ (- (key-size) (bs)) c))
                       updated)))
          ((= (% i) c)
           (loop (++ i)
                 (cons (list-ref state (- i (bs)))
                       updated)))
          (else
           (loop (++ i) 
                 (cons (list-ref state i)
                       updated))))))

(define (e-tick S i j P)
  (let* ((r (row-of S P))
         (c (col-of S P))
         (x (% (+ r ($ (val-at S i j)))))
         (y (% (+ c (% (val-at S i j)))))
         (C (val-at S x y)))
    (let* ((S1 (right-rotate-row S r))
           (c (++% c))
           (y (if (= x r) (++% y) y))
           (j (if (= i r) (++% j) j)))
      (let* ((S2 (down-rotate-col S1 y))
             (x (++% x))
             (r (if (= c y) (++% r) r))
             (i (if (= j y) (++% i) i)))
        (values S2 
                (% (+ i ($ C)))
                (% (+ j (% C)))
                (n->c C))))))

(define (encrypt key nonce text signature)
  (let loop ((S key)
             (i 0)
             (j 0)
             (plain (string->list (string-append nonce text signature)))
             (coded '()))
    (cond ((null? plain) (list->string (drop (reverse coded) (string-length nonce))))
          (else
           (let-values (((S i j C) (e-tick S i j (car plain)))) 
             (loop S i j (cdr plain) (cons C coded)))))))


(define (d-tick S i j C)
  (let* ((x (row-of S C))
         (y (col-of S C))
         (r (% (- x ($ (val-at S i j)))))
         (c (% (- y (% (val-at S i j)))))
         (P (val-at S r c))
         (Cn (c->n C)))
    (let* ((S1 (right-rotate-row S r))
           (c (++% c))
           (y (if (= x r) (++% y) y))
           (j (if (= i r) (++% j) j)))
      (let* ((S2 (down-rotate-col S1 y))
             (x (++% x))
             (r (if (= c y) (++% r) r))
             (i (if (= j y) (++% i) i)))
        (values S2 
                (% (+ i ($ Cn)))
                (% (+ j (% Cn)))
                (n->c P))))))

(define (decrypt key nonce coded)
  (let setup ((S key)
             (i 0)
             (j 0)
             (nonce (string->list nonce)))
    (cond ((null? nonce)
           (let run ((S S)
                     (i i)
                     (j j)
                     (coded (string->list coded))
                     (plain '()))
             (cond ((null? coded) (list->string (reverse plain)))
                   (else
                    (let-values (((S i j P) (d-tick S i j (car coded)))) 
                      (run S i j (cdr coded) (cons P plain)))))))
          (else
           (let-values (((S i j C) (e-tick S i j (car nonce))))
             (setup S i j (cdr nonce)))))))
          
                 
(define sample-key
  (string->key "xv7ydq #opaj_ 39rzut 8b45wc sgehmi knf26l"))

(define (show-run key nonce text signature)
  (newline)
  (newline)
  (say "Key:")
  (show-state key)
  (say "Nonce: " nonce)
  (say "Text: " text)
  (let ((e (encrypt key  nonce text signature)))
    (say "Encrypted: " e)
    (let ((d (decrypt key nonce e)))
      (say "Decrypted: " d)))
  (newline))


; (show-run sample-key "solwbf" "im_about_to_put_the_hammer_down" "#rubberduck")
; (show-run sample-key "argvpx" "hurrrraaaaaaaaaaaaaaaaaaaaaay" "#ben")
