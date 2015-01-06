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

5 Constant MUTATE-PERCENT
GOAL-LENGTH Constant GOAL-SCORE

: make-attempt ( -- addr )
 GOAL-LENGTH rand-string drop ;
 
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
 
: mutate-attempt { addr -- }
 GOAL-LENGTH 0 u+do
   addr i + mutate-char
 loop ;
 
: spawn-attempt ( addr -- new-addr )
 clone-attempt dup mutate-attempt ;
 

: score-attempt-char { addr index -- score }
 addr index + c@
 GOAL-STRING index + c@
 = if 1 else 0 endif ;

: score-attempt { addr -- score }
 0 GOAL-LENGTH 0 u+do
  addr i score-attempt-char +
 loop ;  

: attempt-winner { attempt1 attempt2 -- winner }
 attempt1 score-attempt
 attempt2 score-attempt
 > if attempt1 else attempt2 endif ;


: .attempt ( addr -- )
 dup score-attempt . ." : "
 GOAL-LENGTH type ;

10 Constant WORKSPACE-SIZE

: workspace-range ( ws-addr )
 dup WORKSPACE-SIZE cells + swap ;

: fill-workspace { ws-addr attempt-addr -- }
 ws-addr workspace-range u+do
  attempt-addr spawn-attempt i ! 
 cell +loop ;

: make-workspace { addr -- }
 here WORKSPACE-SIZE cells allot
 dup addr fill-workspace ;

: workspace-attempt ( ws-addr index -- attempt-addr )
  cells + @ ;
  
: workspace-winner { ws-addr -- attemp-addr }
 ws-addr 0 workspace-attempt
 WORKSPACE-SIZE 0 u+do
   ws-addr i workspace-attempt attempt-winner
  loop ;

: .workspace ( ws-addr -- )
 cr workspace-range u+do
  i @ .attempt cr
 cell +loop ;
 
: tick ( generation attempt -- generation+1 improved-atttempt )
 make-workspace workspace-winner
 swap 1+ swap ;
: .tick ( gen attempt )
 swap ." G:" . .attempt cr ;

: bang! ( -- )
 0 make-attempt
 begin
  tick 2dup .tick
  dup score-attempt
  GOAL-SCORE <> while
 repeat .tick ;  