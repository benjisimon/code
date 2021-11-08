\ test out our modules

s" ../modules.fs" required
s" ../utils.fs" required

module

:private x 100 ;

:private 100x x * ;

: grade 3 100x ;

: inner-test
    assert( s" x" find-name 0 = not )
    assert( s" 100x" find-name 0 = not )
    assert( s" grade" find-name 0 = not ) ;

inner-test

publish


: outer-test
    assert( s" x" find-name 0 =  )
    assert( s" 100x" find-name 0 = )
    assert( s" grade" find-name 0 = not ) ;

outer-test

  
