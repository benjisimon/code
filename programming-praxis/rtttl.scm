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
             (implode "," 
               (append
                (buffer 'items)
                (reverse (buffer 'items))))))))
              
(save "hw.rtttl" (morse-rtttl "Hello World"))
(save "sos.rtttl" (morse-rtttl "SOS"))

(for-each (lambda (i)
           (save (&& "rand-" i ".rtttl") (random-song)))
          (range 100 0))


 