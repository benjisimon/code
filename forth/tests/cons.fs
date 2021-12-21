\ test out cons's

:test
    100 200 cons stash
    assert( 100 clash car = )
    assert( 200 clash cdr  = )
    9999 clash set-car!
    assert( 9999 clash car = )
    assert( 200 clash cdr = )
    unstash drop
;


:test
    assert( -1 1 cons cons? true = ) 
    assert( 99 cons? false = ) 
    assert( here cons? false = ) 
;

:test
    assert( 100 200 cons uncons  200 = )
    assert( = 100 ) ;