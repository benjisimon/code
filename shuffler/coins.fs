\ Simple library to implement flipping a coin.

require random.fs
require utils.fs

: face ( -- ) create ;

face heads
face tails

: heads? ( c -- b )  heads = ;
: tails? ( c -- b )  tails = ;
: coin? ( c -- b) dup heads? swap tails? or ;

: flip ( -- c )
    100 random
    50 < if heads else tails endif ;


