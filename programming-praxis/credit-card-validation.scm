; http://programmingpraxis.com/2011/04/08/credit-card-validation/

(define (digits x)
 (cond ((number? x) (digits (number->string x)))
       ((string? x) (map (lambda (c) (string->number (string c)))
                         (string->list x)))
       ((list? x) x)
       (else (error "Unable to extract digits from: " x))))

(define (dstring x)
 (apply string-append (map number->string x)))
 
(define (range x y)
 (cond ((> x y) '())
       (else (cons x (range (+ x 1) y)))))
       
       
(define (lsum num)
 (let* ((ds (reverse (digits num)))
        (is (range 1 (length ds))))
  (apply +
   (map (lambda (d i)
         (if (odd? i)
             d
             (apply + (digits (* d 2)))))
        ds is))))
   
(define (luhn? num)
 (= (modulo (lsum num) 10) 0))

(define (make-luhn num)
 (let* ((ds (append (digits num) (list 0)))
        (sum (lsum ds))
        (check (- 10 (modulo sum 10))))
   (dstring (append (digits num) (list check)))))
 