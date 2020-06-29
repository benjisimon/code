;;
;; A programmer's understanding of exponential growth. and e.
;; https://betterexplained.com/articles/an-intuitive-guide-to-exponential-functions-e/
;;

(define ($ amt)
  (inexact amt))


(define (grow/1 balance rate)
  (let ((interest (* balance (/ rate 100))))
    ($ (+ balance interest))))

(define (grow/2 balance rate frequency)
  (let ((r (if (or (= 0 rate) (= 0 frequency))  0
               (/ (/ rate frequency) 100))))
    (let loop ((balance balance) 
               (frequency frequency))
      (cond ((= frequency 0) ($ balance))
            (else
             (let* ((interest (* balance r)))
               (loop ($ (+ balance interest))
                     (- frequency 1))))))))



(define (grow/3 balance rate)
  ($ (* balance (exp (/ rate 100)))))

