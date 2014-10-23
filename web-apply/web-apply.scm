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

(define (i items index . fallback)
 (cond ((< index (length items))
        (list-ref items index))
       (else
        (if (null? fallback)
            (error "index access error:" index items)
            (car fallback)))))

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

(define (parse-qs qs)
 (let loop ((params (explode "&" qs)) (results '()))
  (cond ((null? params) results)
        (else
         (let ((kv (explode "=" (car params))))
          (loop (cdr params)
                (cons (cons (url-decode (i kv 0))
                            (url-decode (i kv 1 "")))
                      results)))))))

(define (parse-args qs)
 (let ((params (parse-qs qs)))
  (let loop ((index 0) (results '()))
   (cond ((assoc (++ "p" index) params) =>
          (lambda (match)
           (loop (+ index 1) (cons (cdr match) results))))
         (else (reverse results))))))
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
 
(define (web-parse-req line)
 (let* ((parts (explode " " line))
        (uri (explode "?" (i parts 1))))
  `((verb . ,(i parts 0))
    (path . ,(i uri 0))
    (params . ,(parse-qs (i uri 1 "")))
    (args . ,(parse-args (i uri 1 ""))))))
 
(define (web-apply spec req)
 (let ((fn (car spec))
       (converters (cdr spec))
       (params (g req 'args)))
   (cond ((= (length params) (length converters))
          (apply fn
                 (map
                  (lambda (convert value)
                   (cond ((procedure? convert) (convert value))
                         ((eq? convert 'number) (string->number value))
                         ((eq? convert #t) value)
                         (else (error "Invalid conversion: "
                                      convert value))))
                  converters params)))
          (else (++ "Invalid number of arguments provided: " req)))))
                   
  
(define (web-fn-dispatcher mapping)
 (lambda ()
  (with-exception-catcher
   (lambda (ex)
    (web-res 400 '() (++ "Error!"))
    (display-exception ex))
   (lambda ()
    (let* ((input (read-line))
           (req (web-parse-req input)))
     (cond ((not (equal? (g req 'verb) "GET"))
            (web-res 400 '() (++ "D'oh, we only understand GET")))
           ((assoc (g req 'path) mapping) =>
            (lambda (mapping)
             (web-res 200 '() (web-apply (cdr mapping) req))))
           (else
             (web-res 404 '() (++ "No function mapping found")))))))))
             
(define (string-reverse x)
 (apply string
        (reverse (string->list x)))) 

(define (tip-calc amt)
 (map (lambda (percent)
       (cons percent (exact->inexact (+ amt (* (/ percent 100) amt)))))
      '(10 15 20)))
 

(define (bind!)
 (tcp-service-register!
   (list server-address: "*"
    port-number: 9000
    eol-encoding: 'cr-lf)
  (web-fn-dispatcher `(("/rev" . (,string-reverse #t))
                       ("/tip" . (,tip-calc number)))))) 
                            
(define (unbind!)
 (tcp-service-unregister! "*:9000"))
  
