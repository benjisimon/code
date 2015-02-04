;;
;; Morse Code and RTTTL -- encode text as sound
;;


(define morse-map
 '((a * -) (b - * * *) (c - * - *) (d - * *) (e *)
   (f * * - *) (g - - *) (h * * * *) (i * *) (j * - - -)
   (k * - * -) (l * - * *) (m - -) (n - *) (o - - -)
   (p * - * -) (q - - * -) (r * - *) (s * * *)
   (t -) (u * * -) (v * * * -) (w * -) (x - * * -)
   (y - * - -) (z - - * *)))

(define (morse-char x)
 (cond ((equal? x #\space) '(p7))
       (else
         (let* ((c (char-downcase x))
                (s (string->symbol (string c))))
          (cond ((assoc s morse-map) => cdr)
                (else (morse-char #\x)))))))
                
(define (morse-string word)
 (map morse-char (string->list word)))
 
(define (implode sep parts)  
 (let loop ((parts parts) (accum '()))
  (cond ((null? parts) accum)
        (else
         (loop (cdr parts)
               (if (null? accum)
                   (list (car parts))
                   (append accum (list sep (car parts)))))))))
                   
                   
(define (morse-normalize c)
 (case c
  ((*) 's1)
  ((-) 's3)
  (else c)))
            
(define (morse-flatten letters)
 (apply append
        (implode '(p3)
           (map (lambda (letter)
                 (implode 'p1 (map morse-normalize letter)))
                letters))))

(define hw (morse-string "Hello World"))

(define (morse->note sym)
 (case sym
  ((s1) "C")
  ((s3) "C,C,C")
  ((p1) "P")
  ((p3) "P,P,P")
  ((p7) "P,P,P,P,P,P,P")))
  

(define (rtttl text)
 (let* ((morse (morse-flatten (morse-string text)))
        (song (apply string-append
                     (implode "," (map morse->note morse)))))
  (string-append
   text ": d=4, o=5, b=400: " song "\n")))
   
(define (rtttl-save filename text)
 (call-with-output-file filename
  (lambda (out)
   (display (rtttl text) out)))) 