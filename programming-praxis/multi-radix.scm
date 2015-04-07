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

(define (test s t)
 (show t)
 (show (list t (int->mr s (mr->int s t))))
 (show (int->mr s (* 3 (mr->int s t)))))
 
(test hms-spec '(3 4 15))
(test dist-spec '(2 3 0 1))
