;;
;; The geo is responsible for implementing geo utility functions
;;

(define-library (geo)
  (import (scheme base) (utils))

  (export dms->sec 
          sec->dms
          dms->string)

  (begin

    (define (g list x)
      (list-ref list x))

    (define (dms->sec dms)
      (+ (* (g dms 0) (* 60 60))
         (* (g dms 1) 60)
         (g dms 2)))
    
    (define (sec->dms dms)
      (let* ((dms (exact (round dms)))
             (dd (quotient dms (* 60 60)))
             (mm (quotient (- dms (* dd 60 60)) 60))
             (ss  (- dms 
                     (* dd 60 60)
                     (* mm 60))))
        (list dd mm ss)))
    
    (define (dms->string dms direction)
      (string-append
       (number->string (g dms 0)) "°" 
       (number->string (g dms 1)) "'"
       (number->string (g dms 2)) "\""
       direction))
    
    ))
  
  
