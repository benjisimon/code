;; http://programmingpraxis.com/2014/12/05/free-time/

(define (div x y)
 (inexact->exact (floor (exact->inexact (/ x y)))))
 
(define am 'am)
(define pm 'pm)

(define (t hh mm am-pm)
 (+ (* (modulo hh 12) 60)
    mm
    (if (eq? am-pm pm)
        (* 12 60) 0)))
 
(define (fmt-time t)
 (define (pad x)
  (let ((y (number->string x)))
   (if (< x 10) (string-append "0" y) y)))
   
 (let* ((hours (div t 60))
        (mm (pad (modulo t 60)))
        (hh (number->string
             (cond ((> hours 12) (- hours 12))
                    ((= hours 0) 12)
                    (else hours))))
        (am-pm (symbol->string (if (> hours 11) pm am))))
  (string-append hh ":" mm " " am-pm)))
                   
                   
                   
(define (event start stop label)
 (list start stop label))

(define (make-event start-time duration label)
 (event start-time (+ start-time duration) label))

(define (event-start evt)
 (car evt))
(define (event-stop evt)
 (cadr evt))
(define (event-label evt)
 (caddr evt))

(define (fmt-event evt)
 (string-append (fmt-time (event-start evt)) " - "
                (fmt-time (event-stop evt)) ": "
                (event-label evt)))

(define (display-calendar events)
 (for-each (lambda (evt)
            (display (fmt-event evt))
            (newline))
           events))
           
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


(define (merge-all events)
 (let loop ((events events) (result '()))
  (cond ((null? events) result)
        (else
         (loop (cdr events) (merge (car events) result))))))


(define (find-slot duration start-of-day end-of-day calendars)
 (let loop ((calendar (merge-all calendars))
            (start start-of-day))
  (let ((possible (make-event start duration "Meeting")))
   (cond ((> (event-stop possible) end-of-day)
          "Can't schedule the meeting before the end-of-day")
         ((not (overlaps? (car calendar) possible))
          (fmt-event possible))
         (else
          (loop (cdr calendar)
                (+ (event-stop (car calendar)) 5)))))))


(define alice-cal
        (list               
         (event (t 09 20 am) (t 10 00 am) "Meet with Chuck")
         (event (t 11 30 am) (t 12 15 pm) "Meet with Al")))
         
(define bob-cal
        (list
         (event (t 08 15 am) (t 09 30 am) "Team meeting")
         (event (t 02 00 pm) (t 02 30 pm) "Ask for a raise")
         (event (t 10 30 pm) (t 11 55 pm) "Talk with offshore folks")))

(define charlie-cal
        (list
         (event (t 09 15 am) (t 10 15 am) "Breakfast")
         (event (t 10 45 am) (t 12 15 pm) "DND")
         (event (t 02 30 pm) (t 04 20 pm) "Code Club")))
         
(define team-cals (list alice-cal bob-cal charlie-cal))
