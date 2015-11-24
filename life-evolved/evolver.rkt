#lang racket

(require "life.rkt")

(define (mutate?)
  (< (random 100) 10))


(define (evolve init clone mutate grow compare num-generations)
  (cond ([= num-generations 0] init)
        (else
         (let ([results (sort (for/list ([i 100])
                                (grow (mutate (clone init))))
                              compare)])
           (evolve (car resuls)
                   clone
                   mutate grow compare (- num-generations 1))))))
