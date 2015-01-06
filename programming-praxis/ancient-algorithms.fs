\ http://programmingpraxis.com/2014/12/23/ancient-algorithms/

\ -----------------------------------------------------

: odd? ( n -- b )
 1 and 0<> ;
 
: even? ( n -- b )
 odd? 0= ;

: odd-value ( w1 -- w2 )
 dup even? if
  drop 0
 endif ;

: 3rd ( w1 w2 w3 - w1 w2 w3 w1 )
 2 pick ;


: pstep { lhs rhs sum -- new-lhs new-rhs sum }
  lhs 2 /
  rhs 2 * 
  lhs 2 / odd? if
    rhs 2 * sum +
  else
    sum
  endif ;

: pinit { lhs rhs -- sum }
 lhs rhs
 lhs odd? if
   rhs
 else
   0
 endif ;

: product { lhs rhs -- prod }
 lhs rhs pinit
 begin
  pstep
  3rd 1 > while 
 repeat
 2nip ;

: .mul { lhs rhs -- prod1 prod2 }
 lhs rhs product
 lhs rhs *
 .s clearstack ;
 
\ -----------------------------------------------------
 
0.00000001e0 fconstant fsqrt-epsilon

: fwithin? { F: x F: y F: error }
 x y f- fabs
 error f< ;

: fsqrt-needs-refining? { F: x F: n F: x' -- x n x' continue? }
 x' n x'
 x x' fsqrt-epsilon fwithin? IF
  false
 else
  true
 endif ;

: fsqrt-step { F: n F: x -- n x' }
 n
 x n x f/ f+ 2e0 f/ ;


: fsqrt { F: n -- x }
 n 1e0 ftuck
 begin
  fsqrt-step
  fsqrt-needs-refining? while
 repeat
 fnip fnip ; 
 
\ -----------------------------------------------------

: ^2 ( n1 -- n2 )
 dup * ;

: *3 ( n1 n2 n3 -- n4 )
 * * ;
 
: triple { m n -- a b c }
 m ^2  n ^2  -
 2 m n *3
 m ^2 n ^2 + ; 
 
\ -----------------------------------------------------

: gcd-step { m n -- m' n' }
 n 0= if
  m 0
 else
  n m n mod
 endif ;
 
: gcd ( m n -- d )
 begin
  gcd-step
  dup 0<> while
 repeat
 drop ;

\ -----------------------------------------------------

: fpi-init ( -- outer inner )
 3e0 3e0 fsqrt f*
 fdup 2e0 f/ ;
 
: finv ( x -- 1/x )
 1e0 fswap f/ ;
 
: fpi-step { F: outer F: inner -- outer' inner' }
 2e0 outer finv inner finv f+ f/
 fdup inner f* fsqrt ;

: fpi { n -- approx }
 fpi-init
 n 1 u+do
  fpi-step
 loop fdrop ;

\ -----------------------------------------------------


: siv-addr ( s index -- addr )
 1 - cells + ;

: siv-upper ( s -- n )
 @ ;
 
: siv! ( value s index -- )
 siv-addr ! ;
  
: siv@ ( s index -- value )
 siv-addr @ ; 
  
: siv-init { s upper -- s }
 upper s !
 upper 1 + 2 u+do
  true s i siv!
 loop s ;

: siv-range { s start-index -- to from }
 s siv-upper 1 +
 start-index ;
 
: siv.s { s -- }
 s 2 siv-range u+do
  cr i . ." :" s i siv@ .
 loop cr ;

: new-siv { upper -- s }
 here upper cells allot
 upper siv-init ;


: siv-mark { s index -- }
 true s index siv!
 s index 2 * siv-range u+do
  false s i siv!
 index +loop ;
 
: siv-primes { s -- s }
 s 2 siv-range u+do
  s i siv@ if
   s i siv-mark
  endif
 loop s ;

: prime? ( n -- b )
 dup
 new-siv siv-primes
 swap siv@ ;
 
: primes { lower upper -- p1 p2 ... }
 upper new-siv siv-primes { s }
 upper 1+  lower u+do
  s i siv@ if
   i
  endif
 loop ; 