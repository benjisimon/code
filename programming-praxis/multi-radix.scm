;; Mixed Radix Math --
;; http://programmingpraxis.com/2015/04/07/pounds-shillings-pence/
;;

(define time-spec '(7 24 60 60))
(define dist-spec '(1760 3 12))
(define hms-spec '(60 60))
  
(define (mr-factors spec)
 (let loop ((spec (reverse spec)) (current 1) (result '(1)))
  (cond ((null? spec) result)
        (else
         (let ((x (* (car spec) current)))
          (loop (cdr spec) x (cons x result)))))))

(define (mr-normalize spec value)
 (cond ((= (length value) (+ (length spec) 1)) value)
       ((> (length value) (+ (length spec) 1))
        (error "Invalid value: " value spec))
       (else
        (mr-normalize spec (append (list 0) value)))))

(define (mr->int spec value)
 (let ((factors (mr-factors spec))
       (cleaned (mr-normalize spec value)))
  (apply + (map * factors cleaned))))
  
 (define (int->mr spec value)
  (let loop ((value value) (factors (mr-factors spec)) (mr '()))
   (cond ((null? factors) (reverse mr))
         (else
          (let* ((f (car factors))
                 (q (quotient value f))
                 (r (remainder value f)))
           (loop r (cdr factors) (cons q mr)))))))

(define (show . x)
 (for-each display x)
 (newline))

;;
;; Slightly higher level API
;;

(define (make-mr spec value)
 (cons spec value))

(define (mr-spec x) (car x))
 
(define (mr-value x) (cdr x))

 
(define (mr-op op)
 (lambda (x y)
   (let ((xv (mr->int (mr-spec x) (mr-value x)))
         (yv (mr->int (mr-spec y) (mr-value y))))
     (make-mr (mr-spec x) (int->mr (mr-spec x) (op xv yv))))))
   
(define mr-add (mr-op +))
(define mr-sub (mr-op -))
(define mr-mul (mr-op *))
 
(define x (make-mr hms-spec '(3 19 45)))