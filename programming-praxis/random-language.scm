;;
;; Experiment with randomly generated language. Not exactly the
;; buzzword exercise recommended, but close enough.
;;

(define (g elts index)
 (list-ref elts index))

(define (string-join sep parts)
 (let loop ((text "") (parts parts))
  (cond ((null? parts) text)
        ((null? (cdr parts)) (string-append text (car parts)))
        (else
          (loop (string-append text (car parts) sep) (cdr parts))))))

(define (random-element lst)
 (let ((index (random-integer (length lst))))
  (g lst index)))

(define (as-string x)
 (if x (symbol->string x) ""))

(define (random-consonant)
 (let ((src '(b c d f g h j k l
              m n p r s t v w z #f)))
  (as-string (random-element src))))
  
(define (random-vowel)
 (let ((src '(a e i o u)))
  (as-string (random-element src))))

(define (random-syllable)
 (string-append (random-consonant) (random-vowel) (random-consonant)))
 
(define (random-word)
 (let loop ((len (random-element '(1 1 1 2 2 2 3)))
            (parts '()))
  (cond ((= len 0) (string-join "-" parts))
        (else
         (loop (- len 1)
               (cons (random-syllable) parts))))))
               
(define s
 '("to" "be" "or" "not" "to" "be" "that" "is" "the" "question"))

(define (lookup dictionary word)
 (cond ((assoc word dictionary) => cdr)
       (else
        (let loop ((word (random-word)))
         (if (assoc word dictionary)
             (loop (random-word))
             word)))))
             
(define (extend dictionary src dest)
 (if (assoc src dictionary)
     dictionary
     (cons (cons src dest) dictionary)))

(define (translate input)
 (let loop ((dictionary '()) (input input) (output '()))
  (cond ((null? input) (cons (reverse output) dictionary))
        (else
          (let ((word (lookup dictionary (car input))))
           (loop (extend dictionary (car input) word)
                 (cdr input)
                 (cons word output)))))))

 
  
