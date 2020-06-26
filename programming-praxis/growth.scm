;;
;; A programmer's understanding of exponential growth. and e.
;; https://betterexplained.com/articles/an-intuitive-guide-to-exponential-functions-e/
;;

(define ($ amt)
  (inexact amt))

(define (grow balance rate)
  (let ((interest (* balance (/ rate 100))))
    ($ (+ balance interest))))

(define (grow balance rate frequency)
  (let ((r (/ (/ rate frequency) 100)))
    (let loop ((balance balance) (frequency frequency))
      (cond ((= frequency 0) ($ balance))
            (else
             (let ((interest (* balance r)))
               (loop 
                ($ (+ balance interest))
                (- frequency 1))))))))


