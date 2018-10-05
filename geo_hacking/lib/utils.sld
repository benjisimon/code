;;
;; Just a utility file thingy
;;

(define-library (utils)

  (import (scheme base)
          (scheme write))
  (export show)

  (begin

    (define (show . stuff)
      (for-each display stuff)
      (newline))

    ))
