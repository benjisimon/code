\ test out our modules

s" ../modules.fs" required
s" ../utils.fs" required

module

:private x 100 ;

:private 100x x * ;

: grade 3 100x ;


private-words

100 constant alice
variable bob
200 bob !

public-words

: inner-test
    assert( s" x" find-name 0 = not )
    assert( s" 100x" find-name 0 = not )
    assert( s" grade" find-name 0 = not )
    assert( alice bob @ + 300 = ) ;

inner-test


publish


: outer-test
    assert( s" x" find-name 0 =  )
    assert( s" 100x" find-name 0 = )
    assert( s" grade" find-name 0 = not )
    assert( s" bob" find-name 0 = )
;

outer-test

  
