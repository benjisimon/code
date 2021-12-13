\ test out random stuff

:test
    unrandomize
    assert( rand 32583 = )
    assert( rand 21078 = )
    assert( rand 4470 = )
    randomize
    assert( rand 32583 = not )
    unrandomize
    assert( rand 32583 = ) ;
    