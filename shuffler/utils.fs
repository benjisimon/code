\ forth utilities

: ++! ( addr -- )
    dup @ 1+ swap ! ;

: not ( b -- not-b )
    if false else true then ;
