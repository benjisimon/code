;;
;; Utility code
;;

(define (show . stuff)
  (for-each display stuff)
  (newline))

(define *id-src* 0)

(define (gen-id)
  (set! *id-src* (+ *id-src* 1))
  *id-src*)

(define (with-data-from-file file proc)
  (call-with-input-file file
    (lambda (port)
      (proc (read port)))))

(define (freqval val)
  (inexact->exact (* val 1000000)))
