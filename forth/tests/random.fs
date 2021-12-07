\ test out random stuff

:test
    unrandomize
    assert( rand 21103 = )
    assert( rand 3003 = )
    assert( rand 22911 = )
    randomize
    assert( rand 21103 = not )
    unrandomize
    assert( rand 21103 = ) ;
    