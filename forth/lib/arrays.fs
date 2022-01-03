\ Experiment with an array library

module

private-words

: posn ( i addr -- cell )
    swap 1+ cells + ;

: length ( addr -- u )
    @ ;

: fill ( u addr -- )
    dup length 0 +do
        2dup
        i swap posn !
    loop 2drop ;

: each { xt addr -- } ( xt: ... i array-posn -- ... )
    addr length 0 +do
        i i addr posn xt execute 
    loop ;

: values { xt addr -- } ( xt:  ... value -- ... )
    addr length 0 +do
        i addr posn @ xt execute
    loop ;

: debug ( addr -- addr ) ;

create ops
false ,
' length ,
' fill ,
' each ,
' values ,
' debug ,

public-words

: array ( length "name" -- )
    create dup , 1+ cells allot
  does> ( op|index addr -- addr|value )
    swap dup <0 if
        abs cells ops + @ execute
    else
        1+ cells + 
    then ;

: array-length ( "name" -- length )
    -1 ;

: array-fill ( value "name" -- )
    -2 ;

: array-each ( ... xt "name" -- ... ) ( xt: ... i array-posn-addr --  ... )
    -3 ;

: array-values ( ... xt "name" -- ... ) ( xt: ... array-posn-value -- ... )
    -4 ;

: array-debug ( -- addr )
    -5 ;

publish
