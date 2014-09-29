; Blums Mental Hash
; http://programmingpraxis.com/2014/09/26/blums-mental-hash/

; Private Keys
(define f
  '("abcdefghijklmnopqrstuvwxyz." .
    "928372736728736616673726178"))
(define g "9170342658")

; Known keys, for testing
(define f '("abc" . "837"))
(define g "0298736514")

; Utils
(define (string->xs ->x)
  (lambda (str)
    (let ((chars (string->list str)))
      (map ->x (map string chars)))))
(define string->symbols (string->xs string->symbol))
(define string->numbers (string->xs string->number))
      
(define (index-of needle haystack)
  (let loop ((haystack haystack) (index 0))
    (cond ((null? haystack) #f)
          ((equal? (car haystack) needle) index)
          (else
            (loop (cdr haystack) (+ index 1))))))

(define (mod10 x y)
   (modulo (+ x y) 10)) 
(define (first x) (car x))
(define (last  x) (first (reverse x)))
(define (list-ref+1 items index)
  (list-ref items (modulo (+ index 1) (length items))))
  
; The Algorithm
(define (init text)
  (let ((from (string->symbols (car f)))
        (to   (string->numbers (cdr f))))
    (map (lambda (s)
           (let ((index (index-of s from)))
             (list-ref to index)))
         (string->symbols text))))
  
 
(define (step x y)
  (let* ((needle (mod10 x y))
         (haystack (string->numbers g))
         (index (index-of needle haystack)))
    (list-ref+1 haystack index)))
 
 
; Main function
 (define (bmh password)
   (let* ((input (init password))
          (first-step (step (first input) (last input))))
     (let loop ((input (cdr input))
                (last first-step)
                (answer (list first-step)))
       (if (null? input)
           (reverse answer)
           (let ((next-step (step last (car input))))
             (loop (cdr input) next-step (cons next-step answer)))))))
