\ Simple library to implement flipping a coin.

require project.fs

: face ( -- ) create ;

face heads
face tails

: heads? ( c -- b )  heads = ;
: tails? ( c -- b )  tails = ;
: coin? ( c -- b) dup heads? swap tails? or ;

: flip ( -- c )
    100000 random
    odd? if heads else tails endif ;


