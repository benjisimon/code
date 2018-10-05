;;
;; The geo is responsible for implementing geo utility functions
;;

(define-library (geo)
  
  (export dms->sec 
          sec->dms)

  (begin

    (define (dms->sec dms)
      (case (length dms)
        ((1) (car dms))
        ((2) (+ (* (car dms)  60) (cadr dms)))
        ((3) (+ (* (car dms) (* 60 60))
                (* (cadr dms) 60)
                (caddr dms)))))
    
    (define (sec->dms dms)
      (let* ((dd (quotient dms (* 60 60)))
             (mm (quotient (- dms (* dd 60 60)) 60))
             (ss  (- dms 
                     (* dd 60 60)
                     (* mm 60))))
        (list dd mm ss)))
    
    ))
  
  
