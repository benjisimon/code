;;
;; Not an actual programming praxis exercise, but it should be.
;; Implement the spot-it game card sequence
;;
;; Every card matches every other card in exactly one way
;;

#lang scheme

(define (card . syms)
  (apply list syms))

(define (cards-match? c1 c2)
  (define (matches x1 x2)
    (length (filter identity (map (lambda (sym)
                                    (member sym x2))
                                  x1))))
  (let ([m1 (matches c1 c2)]
        [m2 (matches c2 c1)])
    (cond ([= m1 m2 0] #f)
          ([= m1 m2 1] #t)
          (else (error "Invalid card match: " c1 c2)))))

(define c1 (card 1 2 3))
(define c2 (card 7 8 9))
(define c3 (card 7 2 5))
(define c4 (card 1 2 5))

(cards-match? c1 c2)
(cards-match? c1 c3)
(cards-match? c1 c4)
