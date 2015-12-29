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
(define (inc/m x wrap)
  (modulo (inc x) wrap))

(define (sym-generator run-length)
  (let ([src 0]
        [index 0])
    (lambda (action)
      (cond ([eq? action 'fresh]
             (set! src (inc src))
             (set! index 0)
             src)
            (else
             (let ([v src])
               (set! index (inc/m index run-length))
               (when (= 0 index)
                 (set! src (inc src)))
               v))))))

(define (card . syms)
  (apply list syms))

(define (card-add c sym)
  (cons sym c))

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

(define (deck size)
  (make-vector size (card)))

(define (deck-set! deck i card)
  (vector-set! deck i card))

(define (deck-size deck)
  (vector-length deck))

(define (build-deck size)
  (let ([d (deck size)])
    (for ([i size])
      (let ([next-i (inc/m i size)])
        (display (format "~s,~s\n" i next-i))))))
      

(define c1 (card 1 2 3))
(define c2 (card 7 8 9))
(define c3 (card 7 2 5))
(define c4 (card 1 2 5))

(cards-match? c1 c2)
(cards-match? c1 c3)
(cards-match? c1 c4)

(define gen (sym-generator 3))
(gen 'next)
(gen 'next)
(gen 'next)
(gen 'next)
(gen 'fresh)

(build-deck 6)
