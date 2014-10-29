;; A wrapper around Eliza to make her more web friendly

(define random random-integer)

(define (eliza-scrub text)
 (define (valid-char? c)
  (let ((v (char->integer c)))
   (or (equal? c #\space)
       (and (>= v 97) (<= v 122)))))
 (let* ((chars (string->list text))
        (lower (map char-downcase chars))
        (valid (filter valid-char? lower)))
  (apply string valid)))
  
  
(define (eliza-it text)
 (let ((input (map string->symbol (explode " " (eliza-scrub text)))))
  (implode " "
           (apply-rule ELIZA-RULES input))))


(define (bind!)
 (tcp-service-register!
   (list server-address: "*"
    port-number: 9000
    eol-encoding: 'cr-lf)
  (web-fn-dispatcher `(("/doc" . (,eliza-it #t))))))
                            
(define (unbind!)
 (tcp-service-unregister! "*:9000"))
  