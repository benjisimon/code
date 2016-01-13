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

(define (make-symbol-generator)
  (let ([x 0])
    (lambda ()
      (set! x (inc x))
      x)))

(define (card-match? c1 c2)
  (cond ([null? c1] #f)
        ([null? c2] #f)
        ([member (car c1) c2] #t)
        (else (card-match? (cdr c1) c2))))

(define (make-deck n sym-gen)
  (if (exact? (sqrt n))
      (apply append
             (for/list ([i (sqrt n)])
               (let ([sym (sym-gen)])
                 (for/list ([j (sqrt n)])
                   (list sym)))))
      (error "Deck size must a perfect square")))
  
(define (can-add-to-pile? card pile)
  (cond ([null? pile] #t)
        ((not [card-match? (car pile) card])
         (can-add-to-pile? card (cdr pile)))
        (else #f)))

(define (grow-pile pile size deck)
  (cond ([= size 0] pile)
        ([null? deck] #f)
        (else
         (let ([card (car deck)])
           (if (and (can-add-to-pile? card pile)
                    (grow-pile (cons card pile) (dec size) (cdr deck)))
               (grow-pile (cons card pile) (dec size) (cdr deck))
               (grow-pile pile size (cdr deck)))))))


(define (remove-pile-from-deck pile deck)
  (filter (lambda (card)
            (not (memq card pile)))
          deck))

(define (match-pile pile sym-gen)
  (let ([sym (sym-gen)])
    (map (lambda (card)
           (cons sym card))
         pile)))

(define (done? deck)
  (let loop ([cards deck])
    (cond ([null? cards] #t)
          (else
           (if (andmap (lambda (c)
                         (card-match? c (car cards)))
                       deck)
               (loop (cdr cards))
               #f)))))

(define (tick deck sym-gen)
  (let ([psize (sqrt (length deck))])
    (let loop ([i 0] [deck deck] [piles '()])
      (cond ([= i psize]
             (apply append (map (lambda (p)
                                  (match-pile p sym-gen))
                                piles)))
            (else
             (let ([pile (grow-pile '() psize deck)])
               (loop (inc i)
                     (remove-pile-from-deck pile deck)
                     (cons pile piles))))))))

(define (go size)
  (let ([sym-gen (make-symbol-generator)])
    (let loop ([deck (make-deck size sym-gen)])
      (cond ([done? deck] deck)
            (else
             (loop
              (tick deck sym-gen)))))))
  

(go 9)
(go 16)
