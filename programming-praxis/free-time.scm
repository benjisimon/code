;;
;; Scheduling exercise
;;

(define am 'am)
(define pm 'pm)

(define (t hh mm am-pm)
 (+ (* (modulo hh 12) 60)
    mm
    (if (eq? am-pm pm)
        (* 12 60) 0)))
  
(define (event start stop label)
 (list start stop label))
 
(define (event-start evt)
 (car evt))
(define (event-stop evt)
 (cadr evt))
(define (event-label evt)
 (caddr evt))

(define (between? x lower upper)
 (and (>= x lower) (<= x upper)))
 
(define (before? x y)
 (< (event-start x) (event-start y)))

(define (overlaps? x y)
 (or (between? (event-start x) (event-start y) (event-stop y))
     (between? (event-start y) (event-start x) (event-stop x))))

(define (merge a-events b-events)
 (define (join e1 e2)
  (event (min (event-start e1) (event-start e2))
         (max (event-stop e1) (event-stop e2))
         "Busy"))
 (let loop ((a-events a-events)
            (b-events b-events)
            (combined '()))
  (cond ((null? a-events)
         (append combined b-events))
        ((null? b-events)
         (append combined a-events))
        ((overlaps? (car a-events) (car b-events))
         (loop (cdr a-events) (cdr b-events)
               (append
                combined 
                (list (join (car a-events) (car b-events))))))
        ((before? (car a-events) (car b-events))
         (loop (cdr a-events) b-events
               (append combined (list (car a-events)))))
        (else
         (loop a-events (cdr b-events)
               (append combined (list (car b-events)))))))) 

(define alice-cal
        (list               
         (event (t 09 20 am) (t 10 00 am) "Meet with Chuck")
         (event (t 11 30 am) (t 12 15 pm) "Meet with Al")))
         
(define bob-cal
        (list
         (event (t 08 15 am) (t 09 30 am) "Team meeting")
         (event (t 02 00 pm) (t 02 30 pm) "Ask for a raise")
         (event (t 10 30 pm) (t 11 55 pm) "Talk with offshore folks")))
