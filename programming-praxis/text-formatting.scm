; http://programmingpraxis.com/2014/10/07/text-formatting/

(define word-sep #\space)

(define (inc x) (+ 1 x))

(define (slurp port)
  (let loop ((buffer ""))
    (let ((c (read-char port)))
      (cond ((eof-object? c) buffer)
            ((equal? word-sep c) buffer)
            (loop (string-append buffer (string c)))))))

(define (with-words-from-file f thunk)
	 (call-with-input-file f
		  (lambda (port)
		 	   (let loop ((word (slurp port)) (count 0))
		 	     (cond (word (thunk word) (loop (slurp port) (inc count)))
		 	           (else count))))))
		 	           
(define (fmt input output line-width)
  (call-with-output-file output
  			(lambda (port)
  			  (let ((buffer ""))
  			    (with-words-from-file input
  			      (lambda (word)
  			        (cond ((equal? buffer "") (set! buffer word))
  			              ((< (string-length (string-append buffer (string word-sep) word)) line-width)
  			                (set! buffer (string-append buffer (string word-sep) word)))
  			              (else
  			                (display buffer port)
  			                (newline port)
  			                (set! buffer word)))))
  			    (if (> (string-length buffer) 0)
  			      (begin
  			        (display buffer port)
  			        (newline port))))))) 