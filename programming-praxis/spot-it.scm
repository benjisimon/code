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

(define (make-sym-generator)
  (let ([x 0])
    (lambda ()
      (set! x (inc x))
      x)))

(define (card-match? c1 c2)
  (cond ([null? c1] #f)
        ([member (car c1) c2] #t)
        (else (card-match? (cdr c1) c2))))

(define (can-add-to-bucket? card bucket)
  (let loop ([i 0])
    (cond ([>= i (vector-length bucket)] #f)
          ([eq? (vector-ref bucket i) #f] #t)
          ([card-match? (vector-ref bucket i) card] #f)
          (else
           (loop (inc i))))))

(define (make-buckets n)
  (for/vector ([i n])
     (make-vector n #f)))

(define (make-deck n)
  (if (exact? (sqrt n))
      (make-list n '())
      (error "Deck size must a perfect square")))

(define (bucket-add! bucket card)
  (let loop ([i 0])
    (cond ([>= i (vector-length bucket)]
           (error (format "Whoops, no space to store this card: ~s: ~s" card bucket)))
          ([eq? (vector-ref bucket i) #f]
           (vector-set! bucket i card))
          (else
           (loop (inc i))))))

(define (add-to-bucket! card buckets)
  (let loop ([i 0])
    (cond ([>= i (vector-length buckets)]
           (error (format "Can't find a valid bucket for ~s: ~s" card buckets)))
          ([can-add-to-bucket? card (vector-ref buckets i)]
           (bucket-add! (vector-ref buckets i) card))
          (else (loop (inc i))))))

(define (bucket-matchify bucket sym-gen)
  (let ([sym (sym-gen)])
    (for/list ([c bucket])
      (cons sym c))))

(define (tick cards num-buckets sym-generator)
  (let ([buckets (make-buckets num-buckets)])
    (let loop ([cards cards])
      (cond ([null? cards]
             #t)
            (else
             (let ([card (car cards)])
               (add-to-bucket! card buckets)
               (loop (cdr cards))))))
    (let loop ([i 0] [cards '()])
      (cond ([>= i (vector-length buckets)] cards)
            (else
             (loop (inc i)
                   (append cards
                           (bucket-matchify
                            (vector-ref buckets i) sym-generator))))))))


(define (go size)
  (let ([sym-gen (make-sym-generator)])
    (let loop ([generation 0] [cards (make-deck size)])
      (display (format "deck[~s]: ~s\n" generation cards))
      (loop (inc generation) (tick cards (sqrt size) sym-gen)))))

(go 9)
