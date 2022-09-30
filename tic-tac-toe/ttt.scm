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

(define (next-turn t)
  (if (x? t) 'o 'x))


(define (mark-board board symbol location)
  (let loop ((board board)
             (i 0)
             (accum '()))
    (cond ((and (= i location) (_? (car board)))
           (append (reverse accum) (list symbol) (cdr board)))
          ((not (null? board))
           (loop (cdr board)
                 (add1 i)
                 (cons (car board) accum)))
          (else
           (error (format "Invalid move: ~s\n" location))))))


(define (all-locations-are? to-check board player)
  (cond ((null? to-check) #t)
        (else
         (let ((index (car to-check)))
           (if (eq? (list-ref board index) player)
               (all-locations-are? (cdr to-check) board player)
               #f)))))

(define (won? board player)
  (let ((winners '((0 1 2)
                   (3 4 5)
                   (6 7 8)
                   (0 3 6)
                   (1 4 7)
                   (2 5 8)
                   (0 4 8)
                   (2 4 6))))
    (let loop ((winners winners))
      (cond ((null? winners) #f)
            (else
             (let ((w (car winners)))
               (if (all-locations-are? w board player)
                   #t
                   (loop (cdr winners)))))))))

(define (draw? board)
  (let ((available (filter _? board)))
    (null? available)))
        

(define (play)
  (let loop ((board (new-board))
             (turn 'x))
    (show-board board)
    (let ((last-player (next-turn turn)))
    (cond ((won? board last-player)
           (display (format "WINNER: ~s\n" (next-turn turn))))
          ((draw? board)
           (display  "Draw :-(\n"))
          (else
           (display (format "Choose a location to place a ~s: " turn))
           (let ((spot (read)))
             (loop (mark-board board turn spot)
                   (next-turn turn))))))))
    
