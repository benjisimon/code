\ testing out lists

:test
    assert( << >> null? )
    assert( << 100 >> null? not )
    assert( << 1 2 3 >> list? )
    assert( 99 list? not )
    assert( 0 ['] + << 1 2 3 >> fold 6 = )
    assert( ['] 1+ << 100 2 3 >> map car 101 = )
    << 1 2 3 >> { x }
    assert( x length 3 = )
    4 x append!
    assert( x length 4 = )
    assert( x cdr cdr cdr car 4 = )
;

:test
    assert( 100 << ['] 2/ ['] dup ['] * >> execute-list 2500 = )
    << 1 2 3 >> { x }
    << ['] 1+  ['] + >> { ops } 
    assert( 0 ops x fold 9 =  ) 
    ;