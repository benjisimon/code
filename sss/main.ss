;;
;; Work with Shamir Secret Sharing
;; http://kimh.github.io/blog/en/security/protect-your-secret-key-with-shamirs-secret-sharing/
;; https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing#Example
;;



(define ^ expt)
(define (g list index)
  (if (= index 0) (car list) (g (cdr list) (- index 1))))

(define (range lower upper)
  (if (> lower upper) '()
      (cons lower (range (+ 1 lower) upper))))

(define (neg x) (* -1 x))

'
(define (poly-3 t1 t2 t3)
  (lambda (x)
    (+ t1
       (* t2 x)
       (* t3 (^ x 2)))))


(define secret 1234)
(define poly (poly-3 secret 166 94)

(define (share poly x)
  (cons x (poly x)))

(define shares (map (lambda (i)
                      (share poly i))
                    (range 1 6)))
(define sx car)
(define sy cdr)


(define lp (lambda (x)
             (+
              (* 1942 ((poly-3 (/ 10 3) (neg (/ 3 2))  (/ 1 6)) x))
              (* 3402 ((poly-3 (neg 5)  (/ 7 2)        (neg (/ 1 2))) x))
              (* 4414 ((poly-3 (/ 8 3)  (neg 2)        (/ 1 3)) x)))))

(lp 0)
(lp 1)
(lp 2)
shares
              

