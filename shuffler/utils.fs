\ forth utilities

require random.fs

: ++! ( addr -- )
    dup @ 1+ swap ! ;

: not ( b -- not-b )
    if false else true then ;

: >0 ( n -- t|f )
    0 > ;

: odd? ( n -- is-odd? )
    1 and 1 = ;

: randomize ( -- )
    utime drop seed ! ;
