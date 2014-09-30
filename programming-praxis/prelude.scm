;;; standard prelude


; list utilities

(define (take n xs)
  (let loop ((n n) (xs xs) (ys '()))
    (if (or (zero? n) (null? xs))
        (reverse ys)
        (loop (- n 1) (cdr xs)
              (cons (car xs) ys)))))

(define (drop n xs)
  (let loop ((n n) (xs xs))
    (if (or (zero? n) (null? xs)) xs
      (loop (- n 1) (cdr xs)))))

(define (split n xs)
  (let loop ((n n) (xs xs) (zs '()))
    (if (or (zero? n) (null? xs))
        (values (reverse zs) xs)
        (loop (- n 1) (cdr xs) (cons (car xs) zs)))))

(define (take-while pred? xs)
  (let loop ((xs xs) (ys '()))
    (if (or (null? xs) (not (pred? (car xs))))
        (reverse ys)
        (loop (cdr xs) (cons (car xs) ys)))))

(define (drop-while pred? xs)
  (let loop ((xs xs))
    (if (or (null? xs) (not (pred? (car xs)))) xs
      (loop (cdr xs)))))

(define (split-while pred? xs)
  (let loop ((xs xs) (ys '()))
    (if (or (null? xs) (not (pred? (car xs))))
        (values (reverse ys) xs)
        (loop (cdr xs) (cons (car xs) ys)))))

(define (cons* first . rest)
  (let loop ((curr first) (rest rest))
    (if (null? rest) curr
        (cons curr (loop (car rest) (cdr rest))))))

(define (fold-left op base xs)
  (if (null? xs)
      base
      (fold-left op (op base (car xs)) (cdr xs))))

(define (fold-right op base xs)
  (if (null? xs)
      base
      (op (car xs) (fold-right op base (cdr xs)))))

(define (range . args)
  (case (length args)
    ((1) (range 0 (car args) (if (negative? (car args)) -1 1)))
    ((2) (range (car args) (cadr args) (if (< (car args) (cadr args)) 1 -1)))
    ((3) (let ((le? (if (negative? (caddr args)) >= <=)))
           (let loop ((x(car args)) (xs '()))
             (if (le? (cadr args) x)
                 (reverse xs)
                 (loop (+ x (caddr args)) (cons x xs))))))
    (else (error 'range "unrecognized arguments"))))

(define (mappend f . xss) (apply append (apply map f xss)))

(define (iterate n f . bs)
  (let loop ((n n) (b (car bs)) (bs (cdr bs)) (xs '()))
    (if (zero? n) (reverse xs)
      (let ((new-bs (append bs (list (apply f b bs)))))
        (loop (- n 1) (car new-bs) (cdr new-bs) (cons b xs))))))

(define (filter pred? xs)
  (let loop ((xs xs) (ys '()))
    (cond ((null? xs) (reverse ys))
          ((pred? (car xs))
            (loop (cdr xs) (cons (car xs) ys)))
          (else (loop (cdr xs) ys)))))

(define (remove x xs)
  (let loop ((xs xs) (zs '()))
    (cond ((null? xs) (reverse zs))
          ((equal? (car xs) x) (loop (cdr xs) zs))
          (else (loop (cdr xs) (cons (car xs) zs))))))

(define (flatten xs)
  (cond ((null? xs) xs)
        ((pair? xs)
          (append (flatten (car xs))
                  (flatten (cdr xs))))
        (else (list xs))))

(define (all? pred? xs)
  (cond ((null? xs) #t)
        ((pred? (car xs))
          (all? pred? (cdr xs)))
        (else #f)))

(define (any? pred? xs)
  (cond ((null? xs) #f)
        ((pred? (car xs)) #t)
        (else (any? pred? (cdr xs)))))

(define (zip . xss) (apply map list xss))

(define (cross . xss)
  (define (f xs yss)
    (define (g x zss)
      (define (h ys uss)
        (cons (cons x ys) uss))
      (fold-right h zss yss))
    (fold-right g '() xs))
  (fold-right f (list '()) xss))

(define (make-list n x)
  (let loop ((n n) (xs '()))
    (if (zero? n) xs
      (loop (- n 1) (cons x xs)))))

(define (sum xs) (apply + xs))

(define (maximum-by lt? . xs)
  (let loop ((xs (cdr xs)) (current-max (car xs)))
    (cond ((null? xs) current-max)
          ((lt? current-max (car xs))
            (loop (cdr xs) (car xs)))
          (else (loop (cdr xs) current-max)))))


; list comprehensions

(define-syntax fold-of
  (syntax-rules (range in is)
    ((_ "z" f b e) (set! b (f b e)))
    ((_ "z" f b e (v range fst pst stp) c ...)
      (let* ((x fst) (p pst) (s stp)
             (le? (if (positive? s) <= >=)))
        (do ((v x (+ v s))) ((le? p v) b)
          (fold-of "z" f b e c ...))))
    ((_ "z" f b e (v range fst pst) c ...)
      (let* ((x fst) (p pst) (s (if (< x p) 1 -1)))
        (fold-of "z" f b e (v range x p s) c ...)))
    ((_ "z" f b e (v range pst) c ...)
      (fold-of "z" f b e (v range 0 pst) c ...))
    ((_ "z" f b e (x in xs) c ...)
      (do ((t xs (cdr t))) ((null? t) b)
        (let ((x (car t)))
          (fold-of "z" f b e c ...))))
    ((_ "z" f b e (x is y) c ...)
      (let ((x y)) (fold-of "z" f b e c ...)))
    ((_ "z" f b e p? c ...)
      (if p? (fold-of "z" f b e c ...)))
    ((_ f i e c ...)
      (let ((b i)) (fold-of "z" f b e c ...)))))

(define-syntax list-of (syntax-rules ()
  ((_ arg ...) (reverse (fold-of
    (lambda (d a) (cons a d)) '() arg ...)))))

(define-syntax sum-of (syntax-rules ()
  ((_ arg ...) (fold-of + 0 arg ...))))


; pattern matching

(define-syntax list-match
  (syntax-rules ()
    ((_ expr (pattern fender ... template) ...)
      (let ((obj expr))
        (cond ((list-match-aux obj pattern fender ...
                (list template)) => car) ...
              (else (error 'list-match "pattern failure")))))))

(define-syntax list-match-aux
  (lambda (stx)
    (define (underscore? x)
      (and (identifier? x) (free-identifier=? x (syntax _))))
    (syntax-case stx (quote quasiquote)
      ((_ obj pattern template)
        (syntax (list-match-aux obj pattern #t template)))
      ((_ obj () fender template)
        (syntax (and (null? obj) fender template)))
      ((_ obj underscore fender template)
        (underscore? (syntax underscore))
        (syntax (and fender template)))
      ((_ obj var fender template)
        (identifier? (syntax var))
        (syntax (let ((var obj)) (and fender template))))
      ((_ obj (quote datum) fender template)
        (syntax (and (equal? obj (quote datum)) fender template)))
      ((_ obj (quasiquote datum) fender template)
        (syntax (and (equal? obj (quasiquote datum)) fender template)))
      ((_ obj (kar . kdr) fender template)
        (syntax (and (pair? obj)
                (let ((kar-obj (car obj)) (kdr-obj (cdr obj)))
                  (list-match-aux kar-obj kar
                        (list-match-aux kdr-obj kdr fender template))))))
      ((_ obj const fender template)
        (syntax (and (equal? obj const) fender template))))))


; structures

(define-syntax (define-structure x)
  (define (gen-id template-id . args)
    (datum->syntax-object template-id
      (string->symbol
        (apply string-append
               (map (lambda (x)
                      (if (string? x) x
                        (symbol->string
                            (syntax-object->datum x))))
                    args)))))
  (syntax-case x ()
    ((_ name field ...)
     (with-syntax
       ((constructor (gen-id (syntax name) "make-" (syntax name)))
        (predicate (gen-id (syntax name) (syntax name) "?"))
        ((access ...)
          (map (lambda (x) (gen-id x (syntax name) "-" x))
               (syntax (field ...))))
        ((assign ...)
          (map (lambda (x) (gen-id x "set-" (syntax name) "-" x "!"))
               (syntax (field ...))))
        (structure-length (+ (length (syntax (field ...))) 1))
        ((index ...) (let f ((i 1) (ids (syntax (field ...))))
                       (if (null? ids) '()
                         (cons i (f (+ i 1) (cdr ids)))))))
    (syntax (begin
              (define (constructor field ...)
                (vector 'name field ...))
              (define (predicate x)
                (and (vector? x)
                     (= (vector-length x) structure-length)
                     (eq? (vector-ref x 0) 'name)))
              (define (access x) (vector-ref x index)) ...
              (define (assign x update) (vector-set! x index update))
              ...))))))


; matrices

(define (make-matrix rows columns . value)
  (do ((m (make-vector rows)) (i 0 (+ i 1)))
      ((= i rows) m)
    (if (null? value)
        (vector-set! m i (make-vector columns))
        (vector-set! m i (make-vector columns (car value))))))

(define (matrix-rows x) (vector-length x))

(define (matrix-cols x) (vector-length (vector-ref x 0)))

(define (matrix-ref m i j) (vector-ref (vector-ref m i) j))

(define (matrix-set! m i j x) (vector-set! (vector-ref m i) j x))

(define-syntax for
  (syntax-rules ()
    ((for (var first past step) body ...)
      (let ((ge? (if (< first past) >= <=)))
        (do ((var first (+ var step)))
            ((ge? var past))
          body ...)))
    ((for (var first past) body ...)
      (let* ((f first) (p past) (s (if (< first past) 1 -1)))
        (for (var f p s) body ...)))
    ((for (var past) body ...)
      (let* ((p past)) (for (var 0 p) body ...)))))


; hash tables

(define (make-hash hash eql? oops size)
  (let ((table (make-vector size '())))
    (lambda (message . args)
      (if (eq? message 'enlist)
          (let loop ((k 0) (result '()))
            (if (= size k)
                result
                (loop (+ k 1) (append (vector-ref table k) result))))
          (let* ((key (car args))
                 (index (modulo (hash key) size))
                 (bucket (vector-ref table index)))
            (case message
              ((lookup fetch get ref recall)
                (let loop ((bucket bucket))
                  (cond ((null? bucket) oops)
                        ((eql? (caar bucket) key) (cdar bucket))
                        (else (loop (cdr bucket))))))
              ((insert insert! ins ins! set set! store store! install install!)
                (vector-set! table index
                  (let loop ((bucket bucket))
                    (cond ((null? bucket)
                            (list (cons key (cadr args))))
                          ((eql? (caar bucket) key)
                            (cons (cons key (cadr args)) (cdr bucket)))
                          (else (cons (car bucket) (loop (cdr bucket))))))))
              ((delete delete! del del! remove remove!)
                (vector-set! table index
                  (let loop ((bucket bucket))
                    (cond ((null? bucket) '())
                          ((eql? (caar bucket) key)
                            (cdr bucket))
                          (else (cons (car bucket) (loop (cdr bucket))))))))
              ((update update!)
                (vector-set! table index
                  (let loop ((bucket bucket))
                    (cond ((null? bucket)
                            (list (cons key (caddr args))))
                          ((eql? (caar bucket) key)
                            (cons (cons key ((cadr args) key (cdar bucket))) (cdr bucket)))
                          (else (cons (car bucket) (loop (cdr bucket))))))))
              (else (error 'hash-table "unrecognized message")) ))))))

(define (string-hash str)
  (let loop ((cs (string->list str)) (s 0))
    (if (null? cs) s
      (loop (cdr cs) (+ (* s 31)
        (char->integer (car cs)))))))

(define (list->hash hash eql? oops size xs)
  (let ((table (make-hash hash eql? oops size)))
    (do ((xs xs (cdr xs))) ((null? xs) table)
      (table 'insert (caar xs) (cdar xs)))))


; input/output

(define (read-file file-name)
  (with-input-from-file file-name (lambda ()
    (let loop ((c (read-char)) (cs '()))
      (if (eof-object? c) (reverse cs)
        (loop (read-char) (cons c cs)))))))

(define (for-each-input reader proc . pof)
  (let* ((f? (and (pair? pof) (string? (car pof))))
         (p (cond (f? (open-input-file (car pof)))
                  ((pair? pof) (car pof))
                  (else (current-input-port)))))
    (do ((item (reader p) (reader p)))
        ((eof-object? item)
          (if f? (close-input-port p)))
      (proc item))))

(define (map-input reader proc . pof)
  (let* ((f? (and (pair? pof) (string? (car pof))))
         (p (cond (f? (open-input-file (car pof)))
                  ((pair? pof) (car pof))
                  (else (current-input-port)))))
    (let loop ((item (reader p)) (result '()))
      (if (eof-object? item)
          (begin (if f? (close-input-port p)) (reverse result))
          (loop (reader p) (cons (proc item) result))))))

(define (fold-input reader proc base . pof)
  (let* ((f? (and (pair? pof) (string? (car pof))))
         (p (cond (f? (open-input-file (car pof)))
                  ((pair? pof) (car pof))
                  (else (current-input-port)))))
    (let loop ((item (reader p)) (base base))
      (if (eof-object? item)
          (begin (if f? (close-input-port p)) base)
          (loop (reader p) (proc base item))))))

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

(define (filter-input reader pred?)
  (lambda args
    (let loop ((item (apply reader args)))
      (if (or (eof-object? item) (pred? item)) item
        (loop (apply reader args))))))


; strings

(define (string-index c str)
  (let loop ((ss (string->list str)) (k 0))
    (cond ((null? ss) #f)
          ((char=? (car ss) c) k)
          (else (loop (cdr ss) (+ k 1))))))

(define (string-downcase str)
  (list->string
    (map char-downcase
      (string->list str))))

(define (string-upcase str)
  (list->string
    (map char-upcase
      (string->list str))))

(define (string-split sep str)
  (define (f cs xs) (cons (list->string (reverse cs)) xs))
  (let loop ((ss (string->list str)) (cs '()) (xs '()))
    (cond ((null? ss) (reverse (if (null? cs) xs (f cs xs))))
          ((char=? (car ss) sep) (loop (cdr ss) '() (f cs xs)))
          (else (loop (cdr ss) (cons (car ss) cs) xs)))))

(define (string-join sep ss)
  (define (f s ss)
    (string-append s (string sep) ss))
  (define (join ss)
    (if (null? (cdr ss)) (car ss)
      (f (car ss) (join (cdr ss)))))
  (if (null? ss) "" (join ss)))

(define (string-find pat str . s)
  (let* ((plen (string-length pat))
         (slen (string-length str))
         (skip (make-vector plen 0)))
    (let loop ((i 1) (j 0))
      (cond ((= i plen))
            ((char=? (string-ref pat i) (string-ref pat j))
              (vector-set! skip i (+ j 1))
              (loop (+ i 1) (+ j 1)))
            ((< 0 j) (loop i (vector-ref skip (- j 1))))
            (else (vector-set! skip i 0)
                  (loop (+ i 1) j))))
    (let loop ((p 0) (s (if (null? s) 0 (car s))))
      (cond ((= s slen) #f)
            ((char=? (string-ref pat p) (string-ref str s))
              (if (= p (- plen 1))
                  (- s plen -1)
                  (loop (+ p 1) (+ s 1))))
            ((< 0 p) (loop (vector-ref skip (- p 1)) s))
            (else (loop p (+ s 1)))))))


; sorting

(define sort #f)
(define merge #f)
(let ()
  (define dosort
    (lambda (pred? ls n)
      (if (= n 1)
          (list (car ls))
          (let ((i (quotient n 2)))
            (domerge pred?
                     (dosort pred? ls i)
                     (dosort pred? (list-tail ls i) (- n i)))))))
  (define domerge
    (lambda (pred? l1 l2)
      (cond
        ((null? l1) l2)
        ((null? l2) l1)
        ((pred? (car l2) (car l1))
         (cons (car l2) (domerge pred? l1 (cdr l2))))
        (else (cons (car l1) (domerge pred? (cdr l1) l2))))))
  (set! sort
    (lambda (pred? l)
      (if (null? l) l (dosort pred? l (length l)))))
  (set! merge
    (lambda (pred? l1 l2)
      (domerge pred? l1 l2))))

(define (unique eql? xs)
  (cond ((null? xs) '())
        ((null? (cdr xs)) xs)
        ((eql? (car xs) (cadr xs))
          (unique eql? (cdr xs)))
        (else (cons (car xs) (unique eql? (cdr xs))))))

(define (uniq-c eql? xs)
  (if (null? xs) xs
    (let loop ((xs (cdr xs)) (prev (car xs)) (k 1) (result '()))
      (cond ((null? xs) (reverse (cons (cons prev k) result)))
            ((eql? (car xs) prev) (loop (cdr xs) prev (+ k 1) result))
            (else (loop (cdr xs) (car xs) 1 (cons (cons prev k) result)))))))

(define (group-by eql? xs)
  (let loop ((xs xs) (ys '()) (zs '()))
    (cond ((null? xs)
            (reverse (if (null? ys) zs (cons (reverse ys) zs))))
          ((null? (cdr xs))
            (reverse (cons (reverse (cons (car xs) ys)) zs)))
          ((eql? (car xs) (cadr xs))
            (loop (cdr xs) (cons (car xs) ys) zs))
          (else (loop (cddr xs) (list (cadr xs))
                      (cons (reverse (cons (car xs) ys)) zs))))))

(define (vector-sort! vec comp)
  (define-syntax while
    (syntax-rules ()
      ((while pred? body ...)
        (do () ((not pred?)) body ...))))
  (define-syntax assign!
    (syntax-rules ()
      ((assign! var expr)
        (begin (set! var expr) var))))

  (define len (vector-length vec))
  (define-syntax v (syntax-rules () ((v k) (vector-ref vec k))))
  (define-syntax v! (syntax-rules () ((v! k x) (vector-set! vec k x))))
  (define-syntax cmp (syntax-rules () ((cmp a b) (comp (v a) (v b)))))
  (define-syntax lt? (syntax-rules () ((lt? a b) (negative? (cmp a b)))))
  (define-syntax swap! (syntax-rules () ((swap! a b)
    (let ((t (v a))) (v! a (v b)) (v! b t)))))
  (define (vecswap! a b s)
    (do ((a a (+ a 1)) (b b (+ b 1)) (s s (- s 1))) ((zero? s))
      (swap! a b)))

  (define (med3 a b c)
    (if (lt? b c)
        (if (lt? b a) (if (lt? c a) c a) b)
        (if (lt? c a) (if (lt? b a) b a) c)))
  (define (pv-init a n)
    (let ((pm (+ a (quotient n 2))))
      (when (> n 7)
        (let ((pl a) (pn (+ a n -1)))
          (when (> n 40)
            (let ((s (quotient n 8)))
              (set! pl (med3 pl (+ pl s) (+ pl s s)))
              (set! pm (med3 (- pm s) pm (+ pm s)))
              (set! pn (med3 (- pn s s) (- pn s) pn))))
          (set! pm (med3 pl pm pn))))
      pm))

  (let qsort ((a 0) (n len))
    (if (< n 7)
        (do ((pm (+ a 1) (+ pm 1))) ((not (< pm (+ a n))))
          (do ((pl pm (- pl 1)))
              ((not (and (> pl a) (> (cmp (- pl 1) pl) 0))))
            (swap! pl (- pl 1))))
        (let ((pv (pv-init a n)) (r #f)
              (pa a) (pb a) (pc (+ a n -1)) (pd (+ a n -1)))
          (swap! a pv) (set! pv a)
          (let loop ()
            (while (and (<= pb pc) (<= (assign! r (cmp pb pv)) 0))
              (when (= r 0) (swap! pa pb) (set! pa (+ pa 1)))
              (set! pb (+ pb 1)))
            (while (and (>= pc pb) (>= (assign! r (cmp pc pv)) 0))
              (when (= r 0) (swap! pc pd) (set! pd (- pd 1)))
              (set! pc (- pc 1)))
            (unless (> pb pc)
              (swap! pb pc) (set! pb (+ pb 1)) (set! pc (- pc 1)) (loop)))
          (let ((pn (+ a n)))
            (let ((s (min (- pa a) (- pb pa)))) (vecswap! a (- pb s) s))
            (let ((s (min (- pd pc) (- pn pd 1)))) (vecswap! pb (- pn s) s))
            (let ((s (- pb pa))) (when (> s 1) (qsort a s)))
            (let ((s (- pd pc))) (when (> s 1) (qsort (- pn s) s))))))))


; higher-order functions

(define (identity x) x)

(define (constant x) (lambda ys x))

(define (fst x y) x)

(define (snd x y) y)

(define (compose . fns)
  (let comp ((fns fns))
    (cond
      ((null? fns) 'error)
      ((null? (cdr fns)) (car fns))
      (else
        (lambda args
          (call-with-values
            (lambda ()
              (apply
                (comp (cdr fns))
                args))
            (car fns)))))))

(define (complement f) (lambda xs (not (apply f xs))))

(define (swap f) (lambda (x y) (f y x)))

(define (left-section proc . args)
  (lambda xs (apply proc (append args xs))))

(define (right-section proc . args)
  (lambda xs (apply proc (reverse (append (reverse args) (reverse xs))))))

(define-syntax curried-lambda
  (syntax-rules ()
    ((_ () body body* ...)
      (begin body body* ...))
    ((_ (arg arg* ...) body body* ...)
      (lambda (arg)
        (curried-lambda (arg* ...)
          body body* ...)))))

(define-syntax define-curried
  (syntax-rules ()
    ((_ (func arg ...) body body* ...)
      (define func
        (curried-lambda (arg ...)
          body body* ...)))))


; math functions

(define (ipow b e)
  (if (= e 0) 1
    (let loop ((s b) (i e) (a 1)) ; a * s^i = b^e
      (let ((a (if (odd? i) (* a s) a)) (i (quotient i 2)))
        (if (zero? i) a (loop (* s s) i a))))))

(define (isqrt n)
  (if (not (and (positive? n) (integer? n)))
      (error 'isqrt "must be positive integer")
      (let loop ((x n))
        (let ((y (quotient (+ x (quotient n x)) 2)))
          (if (< y x) (loop y) x)))))

(define (ilog b n)
  (let loop1 ((lo 0) (b^lo 1) (hi 1) (b^hi b))
    (if (< b^hi n) (loop1 hi b^hi (* hi 2) (* b^hi b^hi))
      (let loop2 ((lo lo) (b^lo b^lo) (hi hi) (b^hi b^hi))
        (if (<= (- hi lo) 1) (if (= b^hi n) hi lo)
          (let* ((mid (quotient (+ lo hi) 2))
                 (b^mid (* b^lo (expt b (- mid lo)))))
            (cond ((< n b^mid) (loop2 lo b^lo mid b^mid))
                  ((< b^mid n) (loop2 mid b^mid hi b^hi))
                  (else mid))))))))

(define (expm b e m)
  (define (m* x y) (modulo (* x y) m))
  (cond ((zero? e) 1)
        ((even? e) (expm (m* b b) (/ e 2) m))
        (else (m* b (expm (m* b b) (/ (- e 1) 2) m)))))

(define (halve x) (/ x 2))

(define (double x) (+ x x))

(define (square x) (* x x))

(define (add1 x) (+ x 1))

(define (sub1 x) (- x 1))

(define (log2 x) (/ (log x) (log 2)))

(define (log10 x) (/ (log x) (log 10)))

(define (digits n . args)
  (let ((b (if (null? args) 10 (car args))))
    (let loop ((n n) (d '()))
      (if (zero? n) d
          (loop (quotient n b)
                (cons (modulo n b) d))))))

(define (undigits ds . args)
  (let ((b (if (null? args) 10 (car args))))
    (let loop ((ds ds) (n 0))
      (if (null? ds) n
          (loop (cdr ds) (+ (* n b) (car ds)))))))


; bits

(define (logand a b)
  (if (or (zero? a) (zero? b)) 0
    (+ (* (logand (floor (/ a 2)) (floor (/ b 2))) 2)
       (if (or (even? a) (even? b)) 0 1))))

(define (logior x y)
  (cond ((= x y) x)
        ((zero? x) y)
        ((zero? y) x)
        (else
          (+ (* (logior (quotient x 2) (quotient y 2)) 2)
            (if (and (even? x) (even? y)) 0 1)))))

(define (logxor a b)
  (cond ((zero? a) b)
        ((zero? b) a)
        (else
         (+ (* (logxor (floor (/ a 2)) (floor (/ b 2))) 2)
            (if (even? a)
                (if (even? b) 0 1)
                (if (even? b) 1 0))))))

(define (lognot a) (- -1 a))

(define (ash int cnt)
  (if (negative? cnt)
      (let ((n (expt 2 (- cnt))))
        (if (negative? int)
            (+ -1 (quotient (+ 1 int) n))
            (quotient int n)))
      (* (expt 2 cnt) int)))

(define (make-bitvector len . val)
  (let ((v (make-vector
             (ceiling (/ len 8))
             (if (and (pair? val) (= (car val) 1)) 255 0))))
    (if (and (pair? val) (= (car val) 1) (not (zero? (modulo len 8))))
      (do ((i 8 (- i 1))) ((= i (modulo len 8)))
        (vector-set! v (floor (/ len 8))
          (logand (vector-ref v (floor (/ len 8))) (lognot (ash 1 (- i 1)))))))
    (cons v len)))

(define (bitvector-ref bv idx)
  (if (< -1 idx (cdr bv))
      (let ((index (quotient idx 8)) (offset (modulo idx 8)))
        (if (odd? (ash (vector-ref (car bv) index) (- offset))) 1 0))
      (error 'bitvector-ref "out of range")))

(define (bitvector-set! bv idx)
  (if (< -1 idx (cdr bv))
      (let ((index (quotient idx 8)) (offset (modulo idx 8)))
        (vector-set! (car bv) index
          (logior (vector-ref (car bv) index) (ash 1 offset))))
      (error 'bitvector-set! "out of range")))

(define (bitvector-reset! bv idx)
  (if (< -1 idx (cdr bv))
      (let ((index (quotient idx 8)) (offset (modulo idx 8)))
        (vector-set! (car bv) index
          (logand (vector-ref (car bv) index) (lognot (ash 1 offset)))))
      (error 'bitvector-reset! "out of range")))

(define (bitvector-count bv)
  (let* ((counts #(
          0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5
          1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
          1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
          2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7
          1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6
          2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7
          2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7
          3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 5 6 5 6 6 7 5 6 6 7 6 7 7 8))
         (len (cdr bv)) (index (quotient len 8)) (offset (modulo len 8)))
    (do ((i 0 (+ i 1))
         (count 0 (+ count (vector-ref counts (vector-ref (car bv) i)))))
        ((= index i) count))))

(define (bitvector-length bv) (cdr bv))


; random numbers

(define rand #f)
(define randint #f)
(let ((two31 #x80000000) (a (make-vector 56 -1)) (fptr #f))
  (define (mod-diff x y) (modulo (- x y) two31)) ; generic version
  ; (define (mod-diff x y) (logand (- x y) #x7FFFFFFF)) ; fast version
  (define (flip-cycle)
    (do ((ii 1 (+ ii 1)) (jj 32 (+ jj 1))) ((< 55 jj))
      (vector-set! a ii (mod-diff (vector-ref a ii) (vector-ref a jj))))
    (do ((ii 25 (+ ii 1)) (jj 1 (+ jj 1))) ((< 55 ii))
      (vector-set! a ii (mod-diff (vector-ref a ii) (vector-ref a jj))))
    (set! fptr 54) (vector-ref a 55))
  (define (init-rand seed)
    (let* ((seed (mod-diff seed 0)) (prev seed) (next 1))
      (vector-set! a 55 prev)
      (do ((i 21 (modulo (+ i 21) 55))) ((zero? i))
        (vector-set! a i next) (set! next (mod-diff prev next))
        (set! seed (+ (quotient seed 2) (if (odd? seed) #x40000000 0)))
        (set! next (mod-diff next seed)) (set! prev (vector-ref a i)))
      (flip-cycle) (flip-cycle) (flip-cycle) (flip-cycle) (flip-cycle)))
  (define (next-rand)
    (if (negative? (vector-ref a fptr)) (flip-cycle)
      (let ((next (vector-ref a fptr))) (set! fptr (- fptr 1)) next)))
  (define (unif-rand m)
    (let ((t (- two31 (modulo two31 m))))
      (let loop ((r (next-rand)))
        (if (<= t r) (loop (next-rand)) (modulo r m)))))
  (init-rand 19380110) ; happy birthday donald e knuth
  (set! rand (lambda seed
    (cond ((null? seed) (/ (next-rand) two31))
          ((eq? (car seed) 'get) (cons fptr (vector->list a)))
          ((eq? (car seed) 'set) (set! fptr (caadr seed))
                                 (set! a (list->vector (cdadr seed))))
          (else (/ (init-rand (modulo (numerator
                  (inexact->exact (car seed))) two31)) two31)))))
  (set! randint (lambda args
    (cond ((null? (cdr args))
            (if (< (car args) two31) (unif-rand (car args))
              (floor (* (next-rand) (car args)))))
          ((< (car args) (cadr args))
            (let ((span (- (cadr args) (car args))))
              (+ (car args)
                 (if (< span two31) (unif-rand span)
                   (floor (* (next-rand) span))))))
          (else (let ((span (- (car args) (cadr args))))
                  (- (car args)
                     (if (< span two31) (unif-rand span)
                       (floor (* (next-rand) span))))))))))

(define (fortune xs)
  (let loop ((n 1) (x #f) (xs xs))
    (cond ((null? xs) x)
          ((< (rand) (/ n))
            (loop (+ n 1) (car xs) (cdr xs)))
          (else (loop (+ n 1) x (cdr xs))))))

(define (shuffle x)
  (do ((v (list->vector x)) (n (length x) (- n 1)))
      ((zero? n) (vector->list v))
    (let* ((r (randint n)) (t (vector-ref v r)))
      (vector-set! v r (vector-ref v (- n 1)))
      (vector-set! v (- n 1) t))))


; control flow

(define-syntax when
  (syntax-rules ()
    ((when pred? expr ...)
      (if pred? (begin expr ...)))))

(define-syntax unless
  (syntax-rules ()
    ((unless pred? expr ...)
      (if (not pred?) (begin expr ...)))))

(define-syntax while
  (syntax-rules ()
    ((while pred? body ...)
      (do () ((not pred?)) body ...))))

(define-syntax let-values
  (syntax-rules ()
    ((_ () f1 f2 ...) (let () f1 f2 ...))
    ((_ ((fmls1 expr1) (fmls2 expr2) ...) f1 f2 ...)
     (let-values-help fmls1 () () expr1 ((fmls2 expr2) ...) (f1 f2 ...)))))

(define-syntax let-values-help
  (syntax-rules ()
    ((_ (x1 . fmls) (x ...) (t ...) e m b)
     (let-values-help fmls (x ... x1) (t ... tmp) e m b))
    ((_ () (x ...) (t ...) e m b)
     (call-with-values
       (lambda () e)
       (lambda (t ...)
         (let-values m (let ((x t) ...) . b)))))
    ((_ xr (x ...) (t ...) e m b)
     (call-with-values
       (lambda () e)
       (lambda (t ... . tmpr)
         (let-values m (let ((x t) ... (xr tmpr)) . b)))))))


; date arithmetic

(define (julian year month day)
  (let* ((a (quotient (- 14 month) 12))
         (y (+ year 4800 (- a)))
         (m (+ month (* 12 a) -3)))
    (+ day
       (quotient (+ (* 153 m) 2) 5)
       (* 365 y)
       (quotient y 4)
       (- (quotient y 100))
       (quotient y 400)
       (- 32045))))

(define (gregorian julian)
  (let* ((j (+ julian 32044))
         (g (quotient j 146097))
         (dg (modulo j 146097))
         (c (quotient (* (+ (quotient dg 36524) 1) 3) 4))
         (dc (- dg (* c 36524)))
         (b (quotient dc 1461))
         (db (modulo dc 1461))
         (a (quotient (* (+ (quotient db 365) 1) 3) 4))
         (da (- db (* a 365)))
         (y (+ (* g 400) (* c 100) (* b 4) a))
         (m (- (quotient (+ (* da 5) 308) 153) 2))
         (d (+ da (- (quotient (* (+ m 4) 153) 5)) 122))
         (year (+ y (- 4800) (quotient (+ m 2) 12)))
         (month (+ (modulo (+ m 2) 12) 1))
         (day (+ d 1)))
    (values year month day)))

(define (easter year . offset)
  (let* ((a (modulo year 19))
         (b (quotient year 100))
         (c (modulo year 100))
         (d (quotient b 4))
         (e (modulo b 4))
         (f (quotient (+ b 8) 25))
         (g (quotient (+ (- b f) 1) 3))
         (h (modulo (- (+ (* 19 a) b 15) d g) 30))
         (i (quotient c 4))
         (k (modulo c 4))
         (l (modulo (- (+ 32 (* 2 e) (* 2 i)) h k) 7))
         (m (quotient (+ a (* 11 h) (* 22 l)) 451))
         (month (quotient (- (+ h l 114) (* 7 m)) 31))
         (day (+ (modulo (- (+ h l 114) (* 7 m)) 31) 1))
         (q (if (pair? offset) (car offset) 0)))
    (+ (julian year month day) q)))

(define (today) ; Chez Scheme
  (let ((t (current-date)))
    (julian
      (date-year t)
      (date-month t)
      (date-day t))))

(define (today) ; MzScheme
  (let ((today (seconds->date (current-seconds))))
    (julian (date-year today) (date-month today) (date-day today))))


; unit testing

(define-syntax assert
  (syntax-rules ()
    ((assert expr result)
      (if (not (equal? expr result))
          (for-each display `(
            #\newline "failed assertion:" #\newline
            expr #\newline "expected: " ,result
            #\newline "returned: " ,expr #\newline))))))


; miscellaneous

(define-syntax (define-integrable x)
  (define (make-residual-name name)
    (datum->syntax-object name
      (string->symbol
        (string-append "residual-"
          (symbol->string (syntax-object->datum name))))))
  (syntax-case x (lambda)
    ((_ (name . args) . body)
      (syntax (define-integrable name (lambda args . body))))
    ((_ name (lambda formals form1 form2 ...))
     (identifier? (syntax name))
     (with-syntax ((xname (make-residual-name (syntax name))))
       (syntax
         (begin
           (define-syntax (name x)
             (syntax-case x ()
               (_ (identifier? x) (syntax xname))
               ((_ arg (... ...))
                (syntax
                  ((fluid-let-syntax
                     ((name (identifier-syntax xname)))
                     (lambda formals form1 form2 ...))
                   arg (... ...))))))
           (define xname
             (fluid-let-syntax ((name (identifier-syntax xname)))
               (lambda formals form1 form2 ...)))))))))

(define-syntax (define-macro x)
  (syntax-case x ()
    ((_ (name . args) . body)
      (syntax (define-macro name (lambda args . body))))
    ((_ name transformer)
      (syntax
       (define-syntax (name y)
         (syntax-case y ()
           ((_ . args)
             (datum->syntax-object
               (syntax _)
               (apply transformer
                 (syntax-object->datum (syntax args)))))))))))

(define gensym
  (let ((n -1))
    (lambda ()
      (set! n (+ n 1))
      (string->symbol
        (string-append "gensym-"
          (number->string n))))))

(define (box v) (vector v))
(define (unbox box) (vector-ref box 0))
(define (box! box v) (vector-set! box 0 v))