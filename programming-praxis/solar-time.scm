;;
;; The solar-time implmenents functions related to solar time,
;; that is the relationhip between the position of the sun
;;  and time of day
;;
;; See: 
;; https://www.pveducation.org/pvcdrom/properties-of-sunlight/solar-timea
;;

(define (compose . fns)
  (lambda (x)
    (let loop ((fns (reverse fns))
               (result x))
      (cond ((null? fns) result)
            (else
             (loop (cdr fns)
                   ((car fns) result)))))))


(define (r->d r)
  (* r  57.296))

(define (d->r d)
  (* d 0.0175))


;; /d means these work in degrees.
(define cos/d (compose cos d->r))
(define sin/d (compose sin d->r))
(define tan/d (compose tan d->r))
(define acos/d (compose r->d acos))
(define asin/d (compose r->d asin))
(define atan/d (compose r->d atan))1


;; Local Standard Time Merdian
(define (lstm utc-offset)
  (* 15 utc-offset))

(define dc-lstm (lstm -5))
(define dc-lng  38.906849)
(define dc-lng -77.036906)

;; Equation of Time
(define (eot day-of-year)
  (let ((b (* (/ 360 365)
              (- day-of-year 81))))
    (- (* 9.87 (sin/d (* 2 b)))
       (* 7.53 (cos/d b))
       (* 1.5 (sin/d b)))))

;; Time Correction Factor
(define (tcf longitude lstm eot-value)
  (+ (* 4 (- longitude lstm)) eot-value))

(tcf dc-lng dc-lstm (eot 1))

;; Local Solar Time
(define (lst local-time tcf-value)
  (+ local-time (/ tcf-value 60)))

;; Hour Angle
(define (hra lst-value)
  (* 15 (- lst-value 12)))

;; Declination
(define (decl day-of-year)
  (* 23.45
     (sin/d (* (/ 360 365)
               (- day-of-year 81)))))

;; Elevation Angle
(define (elevation decl-value latitude hra-value)
  )
