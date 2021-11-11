\ forth utilities

require random.fs
require modules.fs

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

private-words

10 constant stash-max
here constant the-stash
stash-max cells allot
variable stash-posn
0 stash-posn !

public-words

: stash ( x -- )
    assert( stash-posn @ stash-max  < ) 
    the-stash stash-posn @ cells + !
    1 stash-posn +! ;


: unstash ( -- x )
    assert( stash-posn @ >0 )
    the-stash stash-posn @ 1- cells + @
    -1 stash-posn +! ;


publish