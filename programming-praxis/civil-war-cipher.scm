;;
;; Implement a cipher used in the US Civil War
;; http://www.mathaware.org/mam/06/Sauerberg_route-essay.html
;; https://programmingpraxis.com/2012/03/06/union-route-cipher/
;; http://www.civilwarsignals.org/pages/crypto/crypto.html
;;

(define (show . x)
  (for-each (lambda (x)
              (display x)
              (newline))
            x))

(define (show-6 x)
  (cond ((null? x) #t)
        (else
         (show (take 6 x))
         (fmt-show (drop 6 x)))))

(define (range low high)
  (if (= low high) '()
      (cons low (range (+ 1 low) high))))

(define (index-of x seq)
  (cond ((null? seq) 
         (show `(error index-of ,x))
         #f)
        ((equal? (car seq) x) 0)
        (else
         (+ 1 (index-of x (cdr seq))))))

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

(define (jumble src route)
  (let ((buffer (make-list (length route) '_)))
    (for-each (lambda (elt i)
                (list-set! buffer i elt))
              src
              route)
    buffer))

(define (unjumble src route)
  (let ((buffer (make-list (length route) '_)))
    (for-each (lambda (elt i)
                (list-set! buffer (index-of i route) elt))
              src
              (range 0 (length src)))
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

(define (encode-all words dictionary)
  (map (lambda (w)
         (encode w dictionary))
       words))
         

(define (decode-all words dictionary)
  (map (lambda (w)
         (decode w dictionary))
       words))

(define (encrypt src routes dict)
  (cond ((null? src) '())
        (else
         (let ((found (assoc (car src) routes)))
           (if found
               (let* ((route-name (car found))
                      (seq (cdr found))
                      (lhs (encode-all (take (length seq) (cdr src)) dict))
                      (rhs (drop (+ 1 (length seq)) src)))
                 (append
                  (list route-name)
                  (jumble lhs seq)
                  (encrypt rhs routes dict)))
               `(error unknown-route ,(car src)))))))
           
          
      
(define (decrypt src routes dict)
  (cond ((null? src) '())
        (else
         (let ((found (assoc (car src) routes)))
           (if found
               (let* ((route-name (car found))
                      (seq (cdr found))
                      (lhs (decode-all (take (length seq) (cdr src)) dict))
                      (rhs (drop (+ 1 (length seq)) src)))
                 (append
                  (list route-name)
                  (unjumble lhs seq)
                  (decrypt rhs routes dict)))
               `(error unknow-route ,(car src)))))))
                   
(define (fmt src routes)
  (cond ((null? src) '())
        (else
         (let ((found (assoc (car src) routes)))
           (if found
               (let* ((route-name (car found))
                      (seq (cdr found))
                      (lhs (take (length seq) (cdr src)))
                      (rhs (drop (+ 1 (length seq)) src)))
                 (show '())
                 (show `(cipher ,route-name))
                 (show-6 lhs)
                 (fmt rhs routes))
               `(error unknown-route ,(car src)))))))
               

;;
;; Routes, dictionary and message from http://www.civilwarsignals.org/pages/crypto/crypto.html
;;
(define routes
  '((enemy . (48 24 00 23 47 71
              49 25 01 22 46 70
              50 26 02 21 45 69
              51 27 03 20 44 68
              52 28 04 19 43 67
              53 29 05 18 42 66
              54 30 06 17 41 65
              55 31 07 16 40 64
              56 32 08 15 39 63
              57 33 09 14 38 62
              58 34 10 13 37 61
              59 35 11 12 36 60))

    (stanton . (07 20 34 47 33 19
                06 21 35 46 32 18
                08 05 36 45 31 17
                09 22 04 44 30 16
                10 23 37 03 29 15
                11 24 38 43 02 14
                12 25 39 42 28 01
                13 26 40 41 27 00))

    (mcdowell . (07 20 34 47 33 19
                 06 21 35 46 32 18
                 08 05 36 45 31 17
                 09 22 04 44 30 16
                 10 23 37 03 29 15
                 11 24 38 43 02 14
                 12 25 39 42 28 01
                 13 26 40 41 27 00))))

(define dict '((burnside . burton)
               (enemy . wiley)
               (cavalry . roanoke)
               (our . over)
               (cavalry . relay)
               (rebels . snow)
               (tennessee . godwin)
               (rosecrans . benet)
               (seven-pm . julia)))

(define msg 
  '(enemy 
    __ __ __ boy greatly __
    for burnside the enemy are preparing
    pontoons and increasing numbers on our
    front if they cross between us
    you will go up and probably
    we too x you ought to
    move in the direction at least
    as far as kingston which should
    be strongly fortified and your spare
    stores go into it without delay
    you ought to be free to
    not surely some __ __ __
    
    stanton
    fortune __ __ __ the time
    oppose a crossing and with your
    cavalry to keep open complete and
    rapid communications between us so that
    we can move combinedly on him
    let me hear from you if
    possible at once no news from
    speed this more __ __ __
    
    mcdowell
    must __ __ __ mind horses
    you in ten days our cavalry
    drove the rebels across the tennessee 
    at lambs ferry with loss to
    them of two thousand killed wounded
    prisoners and deserters also five pieces
    artillery yours rosecrans answer quick seven-pm
    men truly gorden __ __ __))

(fmt (encrypt msg routes dict) routes)

(fmt (decrypt (encrypt msg routes dict) routes dict) routes)
