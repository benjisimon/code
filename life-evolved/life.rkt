#lang racket

;;
;; A very primitive implementation of Conway's Game of Life
;;

(define (inc x)
  (+ 1 x))

(define (dec x)
  (- x 1))

(struct cell (x y alive?) #:transparent)

(define (parse-value v)
  (equal? 'X v))

(define (cell-at? c x y)
  (and (= x (cell-x c))
       (= y (cell-y c))))

(define (board-bounds board)
  (let loop ([min-x (cell-x (car board))]
             [min-y (cell-y (car board))]
             [max-x (cell-x (car board))]
             [max-y (cell-y (car board))]
             [board (cdr board)])
    (cond ([null? board] (values min-x min-y max-x max-y))
          (else
           (loop (min min-x (cell-x (car board)))
                 (min min-y (cell-y (car board)))
                 (max max-x (cell-x (car board)))
                 (max max-y (cell-y (car board)))
                 (cdr board))))))


(define (board cells)
  (sort (filter cell-alive? cells)
        (lambda (c1 c2)
          (if (= (cell-x c1) (cell-x c2))
              (< (cell-y c1) (cell-y c1))
              (< (cell-x c1) (cell-x c2))))))

(define (parse-board input)
  (board
   (apply append
          (for/list ([y (in-naturals)]
                     [row input])
            (for/list ([x (in-naturals)]
                       [val row])
              (cell x y (parse-value val)))))))

(define (fold-board fn init board)
  (let-values ([(min-x min-y max-x max-y) (board-bounds board)])
    (let loop ([x min-x]
               [y min-y]
               [carry init]
               [board board])
      (cond ([> y max-y] carry)
            (else
             (let* ([hit? (and (not (null? board))
                               (cell-at? (car board) x y))]
                    [cell (if hit? (car board)
                             (cell x y #f))])
               (let ([carry (fn cell carry)])
                 (loop (if (<= (inc x) max-x) (inc x) min-x)
                       (if (<= (inc x) max-x) y      (inc y))
                       carry
                       (if hit? (cdr board) board)))))))))

(define (for-each-board fn board)
  (fold-board (lambda (cell carry)
                (fn cell)
                carry) (void) board))

(define (display-board board)
  (let-values ([(min-x min-y max-x max-y) (board-bounds board)])
    (for-each-board (lambda (cell)
                      (display (if (cell-alive? cell) 'X '_))
                      (if (= (cell-x cell) max-x)
                          (newline)
                          (display " ")))
                    board)))
  

(define b
  (parse-board '((_ _ X _)
                 (X X X X)
                 (_ X _ X))))

(fold-board (lambda (cell carry)
              (display cell)
              #t)
            #t b)

(display-board b)
