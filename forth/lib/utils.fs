\ forth utilities
module

: @+1! ( addr -- )
    dup @ 1+ swap ! ;

: @+! { u addr -- }
    addr @ u + addr ! ;

: not ( b -- not-b )
    if false else true then ;

: >0 ( n -- t|f )
    0 > ;

: <0 ( n -- t|f )
    0 < ;

: =0 ( n -- t|f )
    0 = ;

: odd? ( n -- is-odd? )
    1 and 1 = ;

: between? { lower upper x -- boolean }
    x lower >= 
    x upper <=
 and ;

: t% ( x y -- x/y-%-truncated )
    100 swap */ ;


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

: clash ( -- x )
    unstash dup stash ;

:private  pow { x y -- x^y }
    x ( -- x )
    y 1 +do
        x *
    loop ;

: ^ ( x y -- x^y )
    dup =0 if 1 else pow then ;


publish