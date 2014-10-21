; http://programmingpraxis.com/2014/10/07/text-formatting/


(define (empty? str)
  (= (string-length str) 0))

(define (++ . args)
  (apply string-append
         (map 
		         (lambda (any)
		           (cond ((string? any) any)
		                 ((number? any) (number->string any))
		                 ((char? any) (string any))))
		         args)))

(define (g options key . default)
  (cond ((assoc key options) => cdr)
        (else (if (null? default)
                  (error "Missing default: " key options)
                  (car default)))))
		          
(define (read-token port)
  (let loop ((buffer ""))
    (let ((c (peek-char port)))
      (cond ((eof-object? c)
             (if (empty? buffer)
                 (cons 'eof (read-char port))
                 (cons 'word buffer)))
            ((equal? c #\newline)
             (if (empty? buffer)
                 (cons 'newline (read-char port))
                 (cons 'word buffer)))
            ((equal? c #\space)
             (if (empty? buffer)
                 (begin (read-char port) (loop buffer))
                 (begin (read-char port) (cons 'word buffer))))
            (else
              (loop (++ buffer (read-char port))))))))

(define (output line port opts)
  (let* ((width (g opts 'width 60))
         (align (g opts 'align 'left))
         (delta (- width (string-length line))))
    (case align
      ((left) (display line port))
      ((right)
       (display (make-string delta #\space) port)
       (display line port))
      ((center)
       (display (make-string (floor (/ delta 2)) #\space) port)
       (display line port)))
    (newline port)))
    
(define (handle-word word buffer out width loop opts)
 (let ((line (if (empty? buffer) "" (++ buffer " "))))
   (if (> (string-length (++ line word)) width)
       (begin
         (output buffer out opts)
         (loop word))
       (begin
         (loop (++ line word))))))


(define (fmt in out opts)
  (call-with-input-file in
    (lambda (pin)
      (call-with-output-file out
        (lambda (pout)
          (format pin pout opts))))))

(define (format in out opts)
  (let ((width (g opts 'width 60)))
    (let loop ((buffer ""))
      (let ((next (read-token in)))
        (case (car next)
          ((eof) (output buffer out opts))
          ((word)
           (handle-word (cdr next) buffer out width loop opts))
          ((newline)
           (let ((peek (read-token in)))
             (case (car peek)
               ((newline)
                (output  buffer out opts)
                (newline out)
                (loop ""))
               ((eof) (output buffer out opts))
               ((word)
                (handle-word (cdr peek) buffer out width loop opts))
               (else (error "Unknown peek token:" peek)))))
          (else (error "Unknown token:" next)))))))

(define in "/sdcard/Documents/input.txt")
(define out  "/sdcard/Documents/output.txt")
(define opts '((width . 30)))

(define (range low high)
  (let loop ((i low) (result '()))
    (if (> i high) (reverse result)
        (loop (+ 1 i) (cons i result)))))

(define-macro (repeat qty . body)
  `(for-each 
    (lambda (i) ,@body) (range 1 ,qty)))
