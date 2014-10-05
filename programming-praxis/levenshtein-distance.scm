; http://programmingpraxis.com/2014/09/12/levenshtein-distance/

(define (unpack x)
  (if (list? x) x 
    (map string (string->list x))))

(define (inc . x)
 (apply + (cons 1 x)))

(define (show . args)
  (for-each (lambda (a) (display a) (display " ")) args)
  (newline))
 
(define (first string)
  (substring string 0 1))
(define (rest string)
  (substring string 1 (string-length string))) 
(define (empty? string)
  (= 0 (string-length string)))
   
(define *cache* '())
(define (get a b)
  (let ((found (assoc (list a b) *cache*)))
    (if found (cdr found) #f)))
    
(define (put! a b distance)
  (if (not (get a b))
    (set! *cache* (cons `((,a ,b) . ,distance) *cache*)))
  distance)
  
  
; Slow version
(define (levn a b)
  (cond ((empty? a) (string-length b))
        ((empty? b) (string-length a))
        (else
          (let ((nudge (if (equal? (first a) (first b)) 0 1)))
            (min
              (inc (levn (rest a) b))
              (inc (levn a (rest b)))
              (+ (levn (rest a) (rest b)) nudge))))))
; Faster              
(define (flevn a b)
  (let ((cached (get a b)))
    (if cached cached
        (put! a b
										  (cond ((empty? a) (string-length b))
										        ((empty? b) (string-length a))
										        (else
										          (let ((nudge (if (equal? (first a) (first b)) 0 1)))
										            (min
										              (inc (flevn (rest a) b))
										              (inc (flevn a (rest b)))
										              (+ (flevn (rest a) (rest b)) nudge)))))))))
										              
