\ Forth module for working with different units of temperature

module

:private scale-up ( x -- x-scaled )
    100 * ;

:private scale-down ( x-scaled -- x )
    50 + 100 / ;

private-words

create unit-symbols
char C c,
char F c,
char K c,

: the-sym ( index -- char )
    unit-symbols + c@ ;

: C ( -- char ) 0 the-sym ;
: F ( -- char ) 1 the-sym ;
: K ( -- char ) 2 the-sym ;

: deg. ( value unit-c -- )
    swap . ." deg " emit ;

public-words

: deg-c ( c -- t )
    scale-up ;

: deg-f ( f -- t )
    scale-up 3200 - 5 9 */ ;

: deg-k ( k -- t )
    scale-up 27315 - ;

: as-deg-f ( t -- f )
    9 5 */ 3200 + scale-down ;

: as-deg-c ( t -- c )
    scale-down ;

: as-deg-k ( t -- k )
    27315 + scale-down ;

: deg-c. ( t -- )
    as-deg-c C deg. ;

: deg-f. ( t -- )
    as-deg-f F deg.  ;

: deg-k. ( t -- )
    as-deg-k K deg. ;

publish