\ forth utilities

: ++! ( addr -- )
    dup @ 1+ swap ! ;
