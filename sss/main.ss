;;
;; Work with Shamir Secret Sharing
;; http://kimh.github.io/blog/en/security/protect-your-secret-key-with-shamirs-secret-sharing/
;; https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing#Example
;; https://www.youtube.com/watch?v=_zK_KhHW6og
;;


(define ^ expt)
(define (g list index)
  (if (= index 0) (car list) (g (cdr list) (- index 1))))

(define (range lower upper)
  (if (> lower upper) '()
      (cons lower (range (+ 1 lower) upper))))

(define (show . words)
  (display words)
  (newline))

(define (pick items indexes)
  (map (lambda (i)
         (g items i))
       indexes))


(define make-share cons)
(define share-x car)
(define share-y cdr)

(define (make-poly coeffs)
  (lambda (x)
    (let loop ((coeffs coeffs)
               (i 0)
               (sum 0))
      (cond ((null? coeffs) sum)
            (else
             (loop (cdr coeffs)
                   (+ i 1)
                   (+ sum (* (car coeffs) (^ x i)))))))))

(define (lagr xs i x)
  (let loop ((product 1)
             (j 0))
    (cond ((= i j) (loop product (+ j 1)))
          ((= j (length xs))  product)
          (else 
           (loop (* (/ (- x (g xs j))
                       (- (g xs i) (g xs j)))
                    product)
                 (+ j 1))))))

(define (make-lagr-poly shares)
  (lambda (x)
    (let loop ((j 0)
               (remaining shares)
               (sum 0))
      (cond ((null? remaining) sum)
            (else
             (loop (+ 1 j)
                   (cdr remaining)
                   (+ sum (* (share-y (car remaining))
                             (lagr (map share-x shares) j x)))))))))


;;
;; Example
;;  - Secret: 911
;;  - Threshold: 7 - need 7 individuals to pool their shares to decode
;;                   the secret
;;
(define share-poly (make-poly '(911 2 27 17 10 37 19))) 


;;
;; Generate 20 shares.
;;
;; Note: (share-poly 0) is our secret -- so don't hand it out.
;;
(define shares (map (lambda (i)
                      (make-share i (share-poly i)))
                    (range 1 20)))

;;
;; Take any 7 shares from the list and generate our solution function.
;;
(define soln (make-lagr-poly (pick shares '(0 1 2 4 5 15 17))))

;;
;; x = 0 is our secret, just like it's our secret in the share fn.
;;
(soln 0)


