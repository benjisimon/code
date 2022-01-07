\ utilities for working with strings

module

: cstring ( c-addr u -- )
    create , ,
  does> ( cstring -- c-addr u )
    dup 1 cells + @ swap @ ;


: string-buffer ( length "name" -- )
    create  dup , 0 , chars 2 cells + allot
  does> ( op addr|index addr -- op-results ... )
    over 0 < if
        swap negate execute
    else
        swap chars 2 cells + +
    then ;
    
:private op ( -- op-flag )
    negate ;
    
:private length ( addr -- n )
    @ ;

: sb-length ( "name" -- length )
    ['] length op ;

:private position ( addr -- n )
    1 cells + @ ;

: sb-position ( "name" -- posn )
    ['] position op ;

:private value ( addr -- c-addr u )
    dup 2 cells + swap position ;

: sb-value ( "name" -- c-addr length )
     ['] value op ;

:private append { c addr -- }
    c addr 2 cells + addr position chars + c!
    addr position 1+ addr 1 cells + ! ;
    
: sb-append ( c "name" -- )
    ['] append op ; 

:private reset ( addr -- )
    1 cells + 0 swap ! ;

: sb-reset ( "name" --  )
    ['] reset op ;

:private fill ( c addr -- )
    dup length 0  +do
        2dup 
        2 cells + i chars + c!
    loop 2drop ;

: sb-fill ( c "name" -- )
    ['] fill op  ;


publish 