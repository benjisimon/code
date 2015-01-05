require random.fs
 
: between? { x lower upper -- bool }
 x lower >= and
 x upper <=  ;

: rand-between { lower upper -- n }
 upper lower -
 random lower + ;

: rand-char ( -- c )
 0 27 rand-between
 dup 26 = IF
  drop bl
 else
  [char] A + 
 endif ;
 
: rand-fill { addr length -- }
 length 0
 u+do
  rand-char addr i + c!
 loop  ;
 
: rand-string { length -- addr length }
 here length chars allot
 dup
 length rand-fill
 length ;

: rand-bool { percent-true -- n }
 100 random
 0 percent-true between? ;

: clone-string { addr length -- addr }
 here length chars allot { new-addr }
 addr new-addr length cmove
 new-addr ;

\ -------------------------------------
s" METHINKS IT IS LIKE A WEASEL"
Constant GOAL-LENGTH

here GOAL-LENGTH chars allot
Constant GOAL-STRING

GOAL-STRING GOAL-LENGTH cmove

25 Constant MUTATE-PERCENT


: make-attempt ( -- addr )
 GOAL-LENGTH rand-string drop ;
 
: .attempt ( addr -- )
 GOAL-LENGTH type ;

: clone-attempt ( addr -- new-addr )
 GOAL-LENGTH clone-string ;

: mutate? ( -- yes-or-no )
 MUTATE-PERCENT rand-bool ;

: mutate-char ( addr -- )
 mutate? IF
  rand-char swap c!
 else
  drop
 endif ;
 
: mutate-attempt { addr -- addr }
 GOAL-LENGTH 0 u+do
   addr i + mutate-char
 loop addr ;

: .x-attempts { n -- }
 make-attempt
 n 0 u+do
  dup
  cr
  clone-attempt
  mutate-attempt
  .attempt
 loop ; 