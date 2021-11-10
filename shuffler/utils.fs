\ forth utilities

: ++! ( addr -- )
    dup @ 1+ swap ! ;

: not ( b -- not-b )
    if false else true then ;

: >0 ( n -- t|f )
    0 > ;