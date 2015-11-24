#lang racket

;;
;; A very primitive implementation of Conway's Game of Life
;;

(provide bang print play)

(define (inc x)
  (+ 1 x))

(define (dec x)
  (- x 1))

(define (bounds board)
  (values (vector-length (vector-ref board 0))
          (vector-length board)))


(define (cell-set! board x y value)
  (let-values ([(w h) (bounds board)])
    (let ([x (modulo x w)]
          [y (modulo y h)])
    (vector-set! (vector-ref board y)
                 x
                 value))))

(define (cell-ref board x y)
  (let-values ([(w h) (bounds board)])
    (let ([x (modulo x w)]
          [y (modulo y h)])
      (vector-ref (vector-ref board y) x))))

(define (neighbors board x y)
  (let ([ref (lambda (x y)
               (cell-ref board x y))])
    (list (ref (dec x) y)
          (ref (dec x) (dec y))
          (ref x       (dec y))
          (ref (inc x) (dec y))
          (ref (inc x) y)
          (ref (inc x) (inc y))
          (ref x       (inc y))
          (ref (dec x) (inc y)))))

(define (print board)
  (for ([row board])
    (for ([cell row])
      (printf "~s " (if cell 'X '_)))
    (newline)))

(define (bang width height init)
  (let ([width (if (eq? width #t) (length (car init)) width)]
        [height (if (eq? height #t) (length init) height)])
    (let ([board (make-vector height)])
      (for ([y height])
        (vector-set! board y (make-vector width #f)))
      (for ([row init]
            [y   (in-naturals)])
        (for ([cell row]
              [x (in-naturals)])
          (when (eq? 'X cell)
            (cell-set! board x y #t))))
      board)))

(define (survive? board x y)
  (let* ([alive? (cell-ref board x y)]
         [friends (neighbors board x y)]
         [num-living-friends (length (filter identity friends))])
    (cond ([and alive? (< num-living-friends 2)] #f)
          ([and alive? (or (= num-living-friends 2)
                           (= num-living-friends 3))] #t)
          ([and alive? (> num-living-friends 3)] #f)
          ([and (not alive?) (= num-living-friends 3)] #t)
          (else #f))))
    
    

(define (tick board)
  (let-values ([(w h) (bounds board)])
    (let ([next (bang w h '())])
      (for ([row board]
            [y (in-naturals)])
        (for ([cell row]
              [x (in-naturals)])
          (cell-set! next x y (survive? board x y))))
      next)))

(define (play generations board)
  (if (= generations 0) board
      (play (dec generations) (tick board))))

