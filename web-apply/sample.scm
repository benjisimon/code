;;
;; Sample Usage of our web-apply

(define (string-reverse x)
 (apply string
        (reverse (string->list x)))) 

(define (tip-calc amt)
 (map (lambda (percent)
       (list percent
             (exact->inexact (* (/ percent 100) amt))
             (exact->inexact (+ amt (* (/ percent 100) amt)))))
      '(10 15 20)))

(define (random-within x y)
 (+ x (random-integer (- y x)))) 

(define (bind!)
 (tcp-service-register!
   (list server-address: "*"
    port-number: 9000
    eol-encoding: 'cr-lf)
  (web-fn-dispatcher `(("/rev" . (,string-reverse #t))
                       ("/tip" . (,tip-calc number))
                       ("/rand" . (,random-within number number)))))) 
                            
(define (unbind!)
 (tcp-service-unregister! "*:9000"))
