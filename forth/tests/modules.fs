\ test out our modules

module

:private x 100 ;

:private 100x x * ;

: grade 3 100x ;


private-words

100 constant alice
variable bob
200 bob !

public-words

:test
    assert( x 100 = )
    assert(  3 100x 300 = )
    assert( alice bob @ + 300 = ) ;

publish


:test
    assert( s" x" find-name 0 =  )
    assert( s" 100x" find-name 0 = )
    assert( s" grade" find-name 0 = not )
    assert( s" bob" find-name 0 = )
;


  
