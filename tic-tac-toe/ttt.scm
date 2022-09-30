;;
;; Let's play tic tac toe
;;


(define (x? v) (eq? v 'x))
(define (o? v) (eq? v 'o))
(define (_? v) (eq? v '_))

(define (add1 x) (+ 1 x))
(define (void) (if #f 1))

(define (new-board)
  '(_ _ _
     _ _ _
     _ _ _))

(define (next-show-board-char i)
  (let ((strings '(" | "
                   " | "
                   "\n--|---|--\n"
                   " | "
                   " | "
                   "\n--|---|--\n"
                   " | "
                   " | "
                   "\n")))
    (list-ref strings i)))

(define (show-board board)
  (let loop ((board board)
             (i 0))
    (cond
     ((null? board) (void))
     (else
      (let ((b (car board)))
        (display (if (_? b) i b))
        (display (next-show-board-char i))
        (loop (cdr board)
              (add1 i)))))))
