;;
;; Morse Code and RTTTL -- encode text as sound
;;


(define (&& . any)
 (apply string-append
        (map (lambda (x)
              (cond ((number? x) (number->string x))
                    ((symbol? x) (symbol->string x))
                    (else x)))
             any)))
             
(define (implode sep parts)  
 (let loop ((parts parts) (accum '()))
  (cond ((null? parts) (apply && accum))
        (else
         (loop (cdr parts)
               (if (null? accum)
                   (list (car parts))
                   (append accum (list sep (car parts)))))))))

(define (string-head text)
 (substring text 0 1))
(define (string-tail text)
 (substring text 1 (string-length text)))

(define (explode sep text)
 (let loop ((text text) (current "") (accum '()))
  (cond ((equal? text "")
         (if (equal? current "")
             (reverse accum)
             (reverse (cons current accum))))
        ((equal? (string-head text) sep)
         (loop (string-tail text)
               ""
               (cons current accum)))
        (else
         (loop (string-tail text)
               (string-append current (string-head text))
               accum))))) 


(define (rtttl title notes)
 (string-append title ":d=4,o=5,b=160:" notes "\n"))
   
(define (save filename contents)
 (call-with-output-file (string-append "/sdcard/Documents/" filename)
  (lambda (out)
   (display contents out)))) 



(define morse-map
 '((a ".-") (b "-...") (c "-.-.") (d "-..") (e ".")
   (f "..-.") (g "--.") (h "....") (i "..") (j ".---")
   (k ".-.-")  (l ".-..") (m "--") (n "-.") (o "---")
   (p ".-.-") (q "--*-") (r ".-.") (s "...")
   (t "-") (u "..-") (v "...-") (w ".-") (x "-..-")
   (y "-.--") (z "--..")))
   
(define (morse-char c)
 (let ((needle (string->symbol (string (char-downcase c)))))
  (cond ((eq? c #\space) " ")
        ((assoc needle morse-map) => cadr)
        (else (morse-char #\x)))))

(define (morse-word text)
 (let ((chars (map morse-char (string->list text))))
  (implode "|" chars)))
  
(define (morse-string text)
 (let ((words (explode " " text)))
  (implode "_" (map morse-word words))))

(define (morse-notes encoded)
 (let loop ((chars (string->list encoded)) (accum '()))
  (cond ((null? chars)
         (implode "," (reverse accum)))
        (else
         (loop
          (cdr chars)
          (cons
           (case (car chars)
            ((#\.) "c5")
            ((#\-) "a7")
            ((#\|) "p")
            ((#\_) "p,p,p"))
           accum))))))
 
(define (morse-rtttl message)
 (rtttl message (morse-notes (morse-string message))))          
 
             
(define (string-reverse text)
 (apply string
        (reverse (string->list text))))
        
(define (range low high)
 (if (> low high) '() (cons low (range (+ 1 low) high))))
 
(define (random-elt items)
 (list-ref items (random-integer (length items))))
 
(define (random-between low high)
 (+ low (random-integer (- high low))))
 
(define (random-note)
 (let ((note (random-elt '(c c c c d d e f g a p)))
       (len  (random-elt '(1 2 4 8 16)))
       (oct  (random-elt '(5 6))))
       
  (if (eq? note 'p)
      (&& len note)
      (&& len note oct))))
      
(define (random-name)
 (&& (random-note) (random-note) (random-note) (random-note)))
 
(define (random-notes)
 (implode
  ","
  (map (lambda (i)
        (random-note))
       (range 0 (random-integer 100)))))
               

(define (make-buffer)
 (let ((buffer '()))
  (lambda (x)
   (if (equal? x 'get)
       (implode "," (reverse buffer))
       (set! buffer (cons x buffer))))))
       
(define (random-song)
 (let ((chorus (random-notes))
       (buffer (make-buffer)))
   (for-each (lambda (i)
              (buffer (random-notes))
              (buffer chorus))
             (range 1 (random-between 5 10)))
   (buffer (random-notes))
   (rtttl "Music By Scheme" (buffer 'get))))
          
(save "hw.rtttl" (morse-rtttl "Hello World"))
(save "sos.rtttl" (morse-rtttl "SOS"))
(save "random.rtttl" (random-song))
 