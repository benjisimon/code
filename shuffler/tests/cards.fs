\ test out our cards

s" ../project.fs" required



:test assert( true ) ;

:test
    assert( 15 rank 2 = )
    assert( 1  suit 0 = )
    assert( 15 suit 1 = )
    assert( 13 suit suit>sym [char] C = )
    assert( 0 suit>sym [char] H = )
    assert( 1 suit>sym [char] C = )
    assert( 2 suit>sym [char] S = )
    assert( 3 suit>sym [char] D = )
    assert( 3 rank>sym [char] 4 = )
    assert( 11 rank>sym [char] Q = )
    assert( 0 rank>sym [char] A = )
    assert( 15 blank? false = )
    assert( 15 blank? not )
    assert( blank blank? )
    assert( 1 suit 1 = not )
;



:test
    cr
    52 0 +do
        i .card
        i 13 mod 0 = i 0 > and if cr else bl emit then
    loop ;
