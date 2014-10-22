; utils
(define (empty? x)
 (cond ((string? x) (= 0 (string-length x)))
       ((list? x) (null? x))
       (else #f)))
       
(define (++ . items)
 (apply string-append (map (lambda (o)
                            (if (string? o) o (object->string o)))
                           items)))
                           
(define (implode sep items)
 (let loop ((items items) (buffer ""))
  (cond ((null? items)
         buffer)
        ((empty? buffer)  (loop (cdr items)
                                (++ (car items))))
        (else
          (loop (cdr items) (++ buffer sep (car items)))))))

(define (g data key . default)
 (cond ((assoc key data) => cdr)
       (else
        (if (null? default)
            (error "Missing attr:" key data)
            (car default)))))

(define (filter pred? items)
 (let loop ((items items) (results '()))
  (cond ((null? items) (reverse results))
        ((pred? (car items))
         (loop (cdr items) (cons (car items) results)))
        (else
         (loop (cdr items) results)))))
         
(define (filter-out pred? items)
 (filter (lambda (item) (not (pred? item))) items))

(define (index-of needle haystack . start)
 (let loop ((i (if (null? start) 0 (car start))))
  (cond ((> (+ i (string-length needle)) (string-length haystack)) #f)
        ((equal? needle (substring haystack i (+ i (string-length needle)))) i)
        (else (loop (+ 1 i))))))
        
(define (explode sep text)
 (let loop ((offset 0) (results '()))
  (let ((pivot (index-of sep text offset)))
   (cond (pivot (loop (+ pivot (string-length sep))
                      (cons (substring text offset pivot) results)))
         (else
          (reverse (cons (substring text offset (string-length text))
                         results)))))))
                         
(define (replace-string from to text)
 (implode to (explode from text)))

(define html-entities '(("&" . "&amp;")
                        ("<" . "&lt;")
                        (">" . "&gt;")))
                        
(define (html-encode html)
 (let loop ((html html) (entities html-entities))
   (cond ((null? entities) html)
         (else
           (let ((m (car entities)))
            (loop (replace-string (car m) (cdr m) html) (cdr entities)))))))
            
(define (url-decode content)
 (let loop ((chars (string->list content)) (buffer ""))
  (cond ((null? chars) buffer)
        ((equal? (car chars) #\+) (loop (cdr chars) (string-append buffer " ")))
        ((equal? (car chars) #\%)
         (let* ((val (string->number
                      (string (cadr chars) (caddr chars)) 16)))
         (loop (cdddr chars)            
               (string-append buffer (string (integer->char val))))))                              
        (else (loop (cdr chars) (string-append buffer (string (car chars))))))))

; web
(define web-codes
 '((200 . "OK")
   (404 . "Not found")
   (400 . "Malformed request")))

(define (web-out . tokens)
 (display (implode " " tokens))
 (newline))

(define (web-res code headers body)
 (web-out "HTTP/1.0" code (g web-codes code))
 (web-out "Content-Type:" (g headers 'Content-Type "text/plain"))
 (for-each (lambda (h)
            (web-out (++ (car h) ":") (cdr h)))
           (filter-out (lambda (h) (eq? 'Content-Type (car h)))
                       headers))
 (web-out)
 (display body))
 
(define (web-fn-dispatcher mapping)
 (lambda ()
  (let ((input (read-line)))
   (web-res 200 '() (++ "You said: " input)))))

(define (string-reverse x)
 (apply string
        (reverse (string->list x)))) 

(define (bind!)
 (tcp-service-register!
   (list server-address: "*"
    port-number: 9000
    eol-encoding: 'cr-lf)
  (web-fn-dispatcher `(("/" . (,string-reverse #t)))))) 
                            
(define (unbind!)
 (tpc-service-unregister! "*:9000"))
  
