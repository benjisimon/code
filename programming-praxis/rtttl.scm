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

(define (string-implode sep parts)
 (apply && (implode sep parts)))       
                   
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
  
(define (rtttl title notes)
 (string-append title ": d=4, o=5, b=400: " notes "\n"))

(define (morse-rtttl text)
 (let* ((morse (morse-flatten (morse-string text)))
        (song (apply string-append
                     (implode "," (map morse->note morse)))))
  (rtttl text song)))
   
(define (save filename contents)
 (call-with-output-file (string-append "/sdcard/Documents/" filename)
  (lambda (out)
   (display contents out)))) 

(define (&& . any)
 (apply string-append
        (map (lambda (x)
              (cond ((number? x) (number->string x))
                    ((symbol? x) (symbol->string x))
                    (else x)))
             any)))
             
             
(define (string-reverse text)
 (apply string
        (reverse (string->list text))))
        
(define (range low high)
 (if (> low high) '() (cons low (range (+ 1 low) high))))
 
(define (random-elt items)
 (list-ref items (random-integer (length items))))
 
(define (random-note)
 (random-elt '(C D E F G A P)))
 
(define (random-name)
 (&& (random-note) (random-note) (random-note) (random-note)))
 
(define (random-notes)
 (let loop ((count (random-integer 20)) (accum '()))
  (cond ((= count 0) accum)
        (else (loop (- count 1) (cons (random-note) accum))))))

(define (make-buffer)
 (let ((buffer '()))
  (lambda (x)
   (if (equal? x 'items)
       (reverse buffer)
       (set! buffer (cons x buffer))))))
       
(define (random-song)
 (let ((notes (random-notes))
       (buffer (make-buffer)))
  (for-each (lambda (duration)
              (for-each (lambda (note)
                          (buffer (&& duration note)))
                        notes))
            '(1 2 4 8 16 32))
    (string-append 
      (rtttl (random-name)
             (string-implode "," 
               (append
                (buffer 'items)
                (reverse (buffer 'items))))))))
              

(save "hw.rtttl" (morse-rtttl "Hello World"))
(save "random.rtttl" (random-song))


 