\ test out life

:test
    4 5 >dimensions

    0 0 0 0
    1 1 1 0
    0 1 1 0
    0 0 0 0
    1 0 0 1 start

    assert( 0 0 posn!  alive? not )
    assert( 0 1 posn!  alive? )
    assert( 1 1 posn!  alive? )
    assert( 0 4 posn!  alive?  )
    assert( 1 4 posn!  alive? not )
;

:test
    assert( 1 1 posn! #living-neighbors 4 = )
    assert( 2 2 posn! #living-neighbors 3 = )
    assert( 0 4 posn! #living-neighbors 1 = )
;

:test
    assert( 0 0 posn! alive? not )
    assert( 1 0 posn! alive? not )
    assert( 2 0 posn! alive? )
    assert( 3 0 posn! alive? not )
;
    
    
