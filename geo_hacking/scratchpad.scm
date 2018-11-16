;;
;; The scratchpad is responsible for playing with geolocation stuff
;;

(import (geo) (utils))

(show
 (let* ((grid-size (dms->sec '(0 7 30)))

        (lat (sec->dms (+ (dms->sec '(38 52 30))
                          (* grid-size (/ 5 11)))))

        (lng (sec->dms (+ (dms->sec '(79 37 30))
                         (* grid-size (/ 3.75 8.5))))))

   (string-append (dms->string lat "N") ", "
                  (dms->string lng "W"))))


(define (sec->cm sec size)
  (/ (* sec size) (dms->sec '(0 7 30))))

(let* ((lat-offset (- (dms->sec '(38 58 19.5))
                      (dms->sec '(38 52 30))))
       (lng-offset (- (dms->sec '(79 23 58.2))
                      (dms->sec '(79 22 30)))))
  (list (sec->cm lat-offset 11)
        (sec->cm lng-offset 8.5)))

