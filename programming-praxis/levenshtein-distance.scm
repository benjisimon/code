; http://programmingpraxis.com/2014/09/12/levenshtein-distance/

(define (unpack x)
  (if (list? x) x 
    (map string (string->list x))))

(define (inc . x)
 (apply + (cons 1 x)))

 
; Slow version
(define (levn a b)
  (let ((a (unpack a))
        (b (unpack b)))
    (cond ((null? a) (length b))
          ((null? b) (length a))
          (else
            (let ((nudge (if (equal? (car a) (car b)) 0 1)))
              (min
                (inc (levn (cdr a) b))
                (inc (levn a (cdr b)))
                (+ (levn (cdr a) (cdr b)) nudge)))))))
                
