;;
;; sun-position implmenents functions related to finding the
;; position of the sun throughout the day.
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
  (* r  57.2958))

(define (d->r d)
  (* d 0.0174533))

;; /d means these work in degrees.
(define cos/d (compose cos d->r))
(define sin/d (compose sin d->r))
(define tan/d (compose tan d->r))
(define acos/d (compose r->d acos))
(define asin/d (compose r->d asin))
(define atan/d (compose r->d atan))


;; Local Standard Time Merdian
(define (lstm utc-offset)
  (* 15 utc-offset))

;; Equation of Time
(define (eot day-of-year)
  (let ((b (* (/ 360 365)
              (- day-of-year 81))))
    (- (* 9.87 (sin/d (* 2 b)))
       (* 7.53 (cos/d b))
       (* 1.5 (sin/d b)))))

;; Time Correction Factor
(define (tcf longitude lstm eot/v)
  (+ (* 4 (- longitude lstm)) eot/v))

;; Local Solar Time
(define (lst local-time tcf/v)
  (+ local-time (/ tcf/v 60)))

;; Hour Angle
(define (hra lst/v)
  (* 15 (- lst/v 12)))

;; Declination
(define (decl day-of-year)
  (* 23.45
     (sin/d (* (/ 360 365)
               (- day-of-year 81)))))

;; Elevation Angle
(define (elevation decl/v latitude hra/v)
  (asin/d (+ (* (sin/d decl/v)
                (sin/d latitude))
             (* (cos/d decl/v)
                (cos/d latitude)
                (cos/d hra/v)))))
;; Zenith Angle
(define (zenith elevation/v) 
  (- 90 elevation/v))

;; Azimuth Angle
(define (azimuth decl/v latitude hra/v)
  (let ((a (let* ((e (elevation decl/v latitude hra/v)))
             (acos/d (/ (- (* (sin/d decl/v)
                              (cos/d latitude))
                           (* (cos/d decl/v)
                              (sin/d latitude)
                              (cos/d hra/v)))
                        (cos/d e))))))
    (if (< hra/v 0) a (- 360 a))))

(define (sunrise decl/v latitude tcf/v)
  (- 12 
     (* (/ 1 15)
        (acos/d (* -1 
                   (tan/d latitude)
                   (tan/d decl/v))))
     (/ tcf/v 60)))

(define (sunset decl/v latitude tcf/v)
  (+ 12
     (- (* (/ 1 15)
           (acos/d (* -1 
                      (tan/d latitude)
                      (tan/d decl/v))))
        (/ tcf/v 60))))

;; Check it.
;; https://www.pveducation.org/pvcdrom/properties-of-sunlight/sun-position-calculator
(let* ((dc-lstm (lstm -5))
       (dc-lat  39)
       (dc-lng  -77)
       (doy     30)
       (lt     (+ 9 (/ 9 60)))
       (eot/v   (eot doy))
       (tcf/v   (tcf dc-lng dc-lstm eot/v))
       (decl/v (decl doy))
       (lst/v  (lst lt tcf/v))
       (hra/v (hra lst/v))
       (e/v   (elevation decl/v dc-lat hra/v))
       (a/v   (azimuth decl/v dc-lat hra/v))
       (sr/v  (sunrise decl/v dc-lat tcf/v))
       (ss/v  (sunset decl/v dc-lat tcf/v)))
  (list e/v a/v))


