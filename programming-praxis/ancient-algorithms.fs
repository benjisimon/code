\ http://programmingpraxis.com/2014/12/23/ancient-algorithms/

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

: pmult { lhs rhs -- prod }
 lhs rhs pinit
 begin
  pstep
  3rd 1 > while 
 repeat
 2nip ;

: .mul { lhs rhs -- prod1 prod2 }
 lhs rhs pmult
 lhs rhs *
 .s clearstack ;