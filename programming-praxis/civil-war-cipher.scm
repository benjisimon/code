;;
;; Implement a cipher used in the US Civil War
;; http://www.mathaware.org/mam/06/Sauerberg_route-essay.html
;; https://programmingpraxis.com/2012/03/06/union-route-cipher/
;;

(define (encrypt src route)
  (if (null? route) 
      '()
      (let ((i (car route)))
        (cons (list-ref src i)
              (encrypt src (cdr route))))))

(define (decrypt src seq)
  (let ((buffer (make-list (length seq) '_)))
    (for-each (lambda (elt i)
                (list-set! buffer i elt))
              src
              seq)
    buffer))

(define route '(3 6 2
                4 7 1
                5 8 0))

(define msg '(Meet at first
              light noext to
             the large pine))

(decrypt (encrypt msg route) route)


                  
                
      
