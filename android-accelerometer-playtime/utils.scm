;;
;; Utilities to help read in accelerometer data
;;


(define (show . stuff)
  (for-each display stuff)
  (newline))

;; Thanks to programming praxis for the helper fns
(define (string-split sep str)
  (define (f cs xs) (cons (list->string (reverse cs)) xs))
  (let loop ((ss (string->list str)) (cs '()) (xs '()))
    (cond ((null? ss) (reverse (if (null? cs) xs (f cs xs))))
          ((char=? (car ss) sep) (loop (cdr ss) '() (f cs xs)))
          (else (loop (cdr ss) (cons (car ss) cs) xs)))))

;; Another goodie by programingpraxis
(define (read-line . port)
  (define (eat p c)
    (if (and (not (eof-object? (peek-char p)))
             (char=? (peek-char p) c))
        (read-char p)))
  (let ((p (if (null? port) (current-input-port) (car port))))
    (let loop ((c (read-char p)) (line '()))
      (cond ((eof-object? c) (if (null? line) c (list->string (reverse line))))
            ((char=? #\newline c) (eat p #\return) (list->string (reverse line)))
            ((char=? #\return c) (eat p #\newline) (list->string (reverse line)))
            (else (loop (read-char p) (cons c line)))))))


;; Call handler on each row in the file.
;; Assume the first row is a header and the
;; following rows are all numeric data
(define (with-data file handler init)
  (call-with-input-file file
    (lambda (port)
      (let ((header-row (read-line port)))
	(let loop ((line (read-line port))
		   (accum init))
	  (cond ((eof-object? line) accum)
		(else
		 (loop (read-line port)
		       (handler accum
				(map string->number (string-split #\, line)))))))))))


		  
