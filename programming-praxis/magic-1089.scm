; http://programmingpraxis.com/2014/10/03/magic-1089/

(define (n->d x)
  (map (lambda (c)
    (string->number (string c)))
    (string->list (number->string x))))

(define (d->n x)
  (string->number (apply string-append (map number->string x))))
  
(define (1089-it n)
  (let* ((n-digits (n->d n))
         (n-digits-rev (reverse n-digits))
         (diff (- (d->n n-digits) (d->n n-digits-rev)))
         (diff-digits (n->d diff))
         (diff-digits-rev (reverse diff-digits))
         (diff-rev (d->n diff-digits-rev))
         (magic (+ diff (d->n diff-digits-rev))))
    `(,n => ,diff +  ,diff-rev = ,magic)))
    
(define (try . xs)
  (for-each (lambda (x) (display (1089-it x)) (newline))
            xs))
            
(try 972 321 961 421)
