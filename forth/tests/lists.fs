\ testing out lists

:test
    assert( << >> null? )
    assert( << 100 >> null? not )
    assert( << 1 2 3 >> list? )
    assert( 99 list? not )
    assert( 0 ['] + << 1 2 3 >> fold 6 = )
    assert( ['] 1+ << 100 2 3 >> map car 101 = )
    << 1 2 3 >> { x }
    4 x append!
    assert( x cdr cdr cdr car 4 = )
;