\ Module to work with bit level stuff

module

: bit-mask ( posn -- n )
    1 swap
    1 +do
        2*
    loop ;

: << ( n places -- n )
    0 +do
        2* 
    loop ;

: bit-on ( n posn -- n )
    bit-mask or ;

: bit-off ( n posn - n  )
    bit-mask invert and ;

: bit-on? ( n posn -- n )
    bit-mask and 0 > ;

: bin. ( n -- )
    ['] . 2 base-execute  ;

publish