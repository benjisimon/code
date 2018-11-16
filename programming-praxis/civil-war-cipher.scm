;;
;; Implement a cipher used in the US Civil War
;; http://www.mathaware.org/mam/06/Sauerberg_route-essay.html
;; https://programmingpraxis.com/2012/03/06/union-route-cipher/
;;

(define (jumble src route)
  (if (null? route) 
      '()
      (let ((i (car route)))
        (cons (list-ref src i)
              (jumble src (cdr route))))))

(define (unjumble src seq)
  (let ((buffer (make-list (length seq) '_)))
    (for-each (lambda (elt i)
                (list-set! buffer i elt))
              src
              seq)
    buffer))

(define (encode word dictionary)
  (cond ((null? dictionary) word)
        ((equal? word (caar dictionary))
         (cdar dictionary))
        (else 
         (encode word (cdr dictionary)))))

(define (decode word dictionary)
  (cond ((null? dictionary) word)
        ((equal? word (cdar dictionary))
         (caar dictionary))
        (else 
         (decode word (cdr dictionary)))))

(define (encrypt src seq dict)
  (jumble (map (lambda (w) 
                 (encode w dict)) 
               src) 
          seq))

(define (decrypt src seq dict)
  (unjumble (map (lambda (w) 
                 (decode w dict)) 
               src) 
          seq))

(define (take n src)
  (cond ((= n 0) '())
        ((null? src) '())
        (else
         (cons (car src)
               (take (- n 1)
                     (cdr src))))))

(define (drop n src)
  (cond ((= n 0) src)
        ((null? src) '())
        (else
         (drop (- n 1) (cdr src)))))

(define (group-into size src)
  (let ((g (take size src)))
    (cond ((null? g) '())
          (else
           (cons g (group-into size (drop size src)))))))


(define route '(3 6 2
                4 7 1
                5 8 0))

(define msg '(meet at first
              light next to
             the large pine))

(define dict '((meet . cow)
               (next . lightbulb)
               (pine . the)))


(encode 'meet dict)
(encode 'friday dict)
(decode (encode 'meet dict) dict)
(decode (encode 'friday dict) dict)

(unjumble (jumble msg route) route)

(group-into 3 (encrypt msg route dict))
(group-into 3 (decrypt (encrypt msg route dict) route dict))


                  
                
      
