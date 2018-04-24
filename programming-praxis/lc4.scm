;; http://programmingpraxis.com/2018/03/27/elsie-four/

(import (srfi 27)
        (srfi 1))

(define (show . x)
  (display x)
  (newline))

(define *alphabet*  (string->list "#_23456789abcdefghijklmnopqrstuvwxyz"))

(define (random-elt l next)
  (if (= 1 (length l))
    (next (car l) '())
    (let* ((index (random-integer (length l)))
           (value (list-ref l index))
           (updated (filter (lambda (elt)
                              (not (equal? elt value)))
                            l)))
      (next value updated))))


(define (make-key)
  (let loop ((pool *alphabet*)
             (key '()))
    (if (null? pool)
      key
      (random-elt pool
                  (lambda (x pool)
                    (show pool))))))
    
         
    
