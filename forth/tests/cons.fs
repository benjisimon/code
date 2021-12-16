\ test out cons's

:test
    100 200 cons stash
    assert( 100 clash car = )
    assert( 200 clash cdr = )
    9999 clash set-car!
    assert( 9999 clash car = )
    assert( 200 clash cdr = )
    unstash
;