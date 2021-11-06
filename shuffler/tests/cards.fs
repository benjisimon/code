\ test out our cards

s" ../cards.fs" required

: core
    assert( 15 rank 2 = )
    assert( 1  suit 0 = )
    assert( 15 suit 1 = )
    assert( 13 suit suit>sym [char] C = )
    assert( 0 suit>sym [char] H = )
    assert( 1 suit>sym [char] C = )
    assert( 2 suit>sym [char] S = )
    assert( 3 suit>sym [char] D = )
;

core