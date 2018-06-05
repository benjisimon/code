;; https://programmingpraxis.com/2018/05/29/blockchain/

(import (srfi 27)
        (srfi 151)
        (srfi 69)
        (srfi 1))

;; Utilities
(define (%256 x)
  (modulo x 256))

(define (++ x)
  (+ x 1))
(define (-- x)
  (- x 1))

(define (g items key default)
  (cond ((assoc key items) => cdr)
        (else default)))

(define (s++ string)
  (let ((first (car (string->list string)))
        (rest (cdr (string->list string))))
    (list->string (cons (integer->char (%256 (++ (char->integer first))))
                        rest))))

(define (show . stuff)
  (for-each display stuff)
  (newline))

(define (range lower upper)
  (if (< lower upper)
    (cons lower (range (+ 1 lower) upper))
    '()))

;; Pearson Hashing
(define *PEARSON-HASH-TABLE* #(249 40 2 210 228 60 134 7 97 80 219 26 140 4 142 239 169
177 67 98 253 108 87 183 56 153 171 59 124 29 159 62 185 8 115 163 164
5 231 38 168 9 27 58 12 109 175 238 16 81 195 147 221 76 182 86 241 57
218 138 220 244 126 158 121 136 66 227 173 252 135 199 72 48 123 43
236 13 207 79 233 216 114 34 61 245 55 118 120 32 203 74 28 20 254 223
217 33 179 18 132 188 166 70 193 41 106 186 85 77 47 143 201 88 146
194 125 53 214 247 24 160 250 234 197 180 222 31 0 65 51 50 196 92 103
167 232 176 42 154 149 68 15 78 240 145 3 226 212 172 23 151 152 192
107 187 133 93 30 63 224 104 19 131 205 101 198 230 129 73 155 75 204
100 206 110 208 184 35 162 52 21 150 215 248 89 235 91 165 84 255 95
25 161 130 242 36 229 6 39 1 112 170 90 117 237 174 14 144 49 99 83
116 181 54 246 209 64 11 251 37 157 94 127 128 200 243 82 45 156 71
102 225 105 202 139 44 141 46 111 137 17 178 211 148 213 22 119 113 96
122 10 69 189 190 191))

(define (phash text)
  (let loop ((hash 0)
             (chars (map char->integer (string->list text))))
    (cond ((null? chars) hash)
          (else
           (loop (vector-ref *PEARSON-HASH-TABLE*
                             (bitwise-xor hash (car chars)))
                   (cdr chars))))))

(define (phash/128 text)
    (let loop ((text text)
               (bytes 16)
               (results '()))
      (cond ((= bytes 0) 
             (apply string-append 
                    (map (lambda (r)
                           (number->string r 16))
                         results)))
            (else
             (loop (s++ text) (-- bytes) 
                   (cons (phash text) results))))))

;; Blockchains
(define (make-block index data previous-hash hash)
  (list index data previous-hash hash))
(define (block-index b)
  (list-ref b 0))
(define (block-data b)
  (list-ref b 1))
(define (block-previous-hash b)
  (list-ref b 2))
(define (block-hash b)
  (list-ref b 3))


(define (bc-init)
  (list (make-block 0 "Genesis Block" "0" (phash/128 "0Genesis Block0"))))

(define (bc-adjoin bc data)
  (let ((prev (car bc)))
    (cons
     (make-block (++ (block-index prev))
                 data
                 (block-hash prev)
                 (phash/128 (string-append 
                             (number->string (++ (block-index prev)))
                             data
                             (block-hash prev))))
     bc)))

(define (bc-valid? bc)
  (let loop ((bc bc))
    (let ((current (car bc)))
      (cond ((= (block-index current) 0)
             (equal? (block-data current) "Genesis Block"))
            (else
             (let ((prev (cadr bc)))
               (if (equal? (phash/128
                            (string-append
                             (number->string (block-index current))
                                 (block-data current)
                                 (block-hash prev)))
                           (block-hash current))
                     (loop (cdr bc))
                     #f)))))))

(define (bc-show bc)
  (if (bc-valid? bc)
      (for-each show bc)
      (error "Refusing to show blockchain because it's not valid" bc)))
    

;; Example from: 
;; https://waterdata.usgs.gov/md/nwis/uv?cb_00060=on&cb_00065=on&format=rdb&site_no=01646500&period=1&begin_date=2018-05-29&end_date=2018-06-05
(define water-guage-levels 
  '("USGS    2018-06-04 00:00    EST    70200    P    7.78    P"
    "USGS    2018-06-04 00:15    EST    70600    P    7.80    P"
    "USGS    2018-06-04 00:30    EST    70900    P    7.81    P"
    "USGS    2018-06-04 00:45    EST    71500    P    7.84    P"
    "USGS    2018-06-04 01:00    EST    72300    P    7.88    P"
    "USGS    2018-06-04 01:15    EST    72500    P    7.89    P"
    "USGS    2018-06-04 01:30    EST    73300    P    7.93    P"
    "USGS    2018-06-04 01:45    EST    74200    P    7.97    P"
    "USGS    2018-06-04 02:00    EST    75000    P    8.01    P"
    "USGS    2018-06-04 02:15    EST    76100    P    8.06    P"
    "USGS    2018-06-04 02:30    EST    76500    P    8.08    P"
    "USGS    2018-06-04 02:45    EST    77400    P    8.12    P"
    "USGS    2018-06-04 03:00    EST    79100    P    8.20    P"
    "USGS    2018-06-04 03:15    EST    79800    P    8.23    P"
    "USGS    2018-06-04 03:30    EST    81100    P    8.29    P"
    "USGS    2018-06-04 03:45    EST    82500    P    8.35    P"))

(define water-guage-levels-bc
  (fold (lambda (entry bc)
          (bc-adjoin bc entry))
        (bc-init)
        water-guage-levels))

(define (attack-water-guage-levels)
  (let ((target (list-ref water-guage-levels-bc 3)))
    (list-set! target 1 "USGS    2018-06-04 03:00    EST    79100    P    7.90    P")
    (list-set! water-guage-levels-bc 3 target)))

          


