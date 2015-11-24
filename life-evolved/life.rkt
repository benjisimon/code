#lang racket

;;
;; A very primitive implementation of Conway's Game of Life
;;

(define (cell-set! board x y value)
  (vector-set! (vector-ref board y)
               x
               value))

(define (cell-ref board x y)
  (vector-ref (vector-ref board y) x))

(define (print board)
  (for ([row board])
    (for ([cell row])
      (printf "~s " (if cell 'X '_)))
    (newline)))

(define (bang width height init)
  (let ([board (make-vector height)])
    (for ([y height])
      (vector-set! board y (make-vector width #f)))
    (for ([row init]
          [y   (in-naturals)])
      (for ([cell row]
            [x (in-naturals)])
        (when (eq? 'X cell)
          (cell-set! board x y #t))))
    board))

(define b
  (bang 20 20
        '((_ X _ X)
          (_ _ X X)
          (X _ _ _))))

(define c
  (bang 3 3
        '((X))))

(print b)
