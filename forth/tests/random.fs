\ test out random stuff

:test
    unrandomize
    assert( rand 13302831534993000 = )
    assert( rand 252099664 = )
    assert( rand 25433 = )
    randomize
    assert( rand 13302831534993000 = not )
    unrandomize
    assert( rand 13302831534993000 = ) ;
    