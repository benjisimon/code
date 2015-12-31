;;
;; Not an actual programming praxis exercise, but it should be.
;; Implement the spot-it game card sequence
;;
;; Every card matches every other card in exactly one way
;;

#lang scheme

(define (inc x)
  (+ x 1))
(define (dec x)
  (- x 1))

(define (init-deck size)
  (for/vector ([i size])
    (list)))

(define (card-match? c1 c2)
  (cond ([null? c1] #f)
        ([member (car c1) c2] #t)
        (else (card-match? (cdr c1) c2))))

(define (find-matches c deck)
  (filter (lambda (x)
            (card-match? c x)) (vector->list deck)))

(define (random-symbol deck)
  (random (vector-length deck)))

(define (random-card-position deck)
  (random (vector-length deck)))

(define (can-add? sym card deck)
  (cond ([member sym card] #t)
        (else
         (let ([suspects (find-matches card deck)])
           (let loop ([suspects suspects])
             (cond ([null? suspects] #t)
                   ([member sym (car suspects)] #f)
                   (else
                    (loop (cdr suspects)))))))))

(define (add-sym card sym)
  (if (member sym card)
      card
      (cons sym card)))
      
(define (tick! deck)
  (let* ([p1 (random-card-position deck)]
         [p2 (random-card-position deck)]
         [c1 (vector-ref deck p1)]
         [c2 (vector-ref deck p2)])
    (cond ([card-match? c1 c2] deck)
          (else
           (let ([sym (random-symbol deck)])
            (when (and (can-add? sym c1 deck)
                       (can-add? sym c2 deck))
              (vector-set! deck p1 (add-sym c1 sym))
              (vector-set! deck p2 (add-sym c2 sym)))
            deck)))))

(define d (init-deck 48))
(tick! d)
(for ([i 10000])
  (tick! d))
d

(length (find-matches (vector-ref d 0) d))
  
