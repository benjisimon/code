require random.fs

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

