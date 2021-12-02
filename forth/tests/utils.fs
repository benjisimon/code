\ test out utils

create foo 0 ,

:test
    assert( foo @ 0 = )
    foo @+1!
    assert( foo @ 1 = ) ;
:test
    assert( 1 1 + 3 = not )
    assert( 1 1 + 2 = not not )
    assert( 10 >0 )
    assert( 0 >0 not )
    assert( 3 odd? )
    assert( 383837721 odd? )
    assert( 383732 odd? not )
;

:test
    unrandomize
    assert( 100 random 0 = )
    assert( 100 random 0 = )
    assert( 100 random 0 = )
    assert( 100 random 17 = )
    randomize
    assert( 100 random 78 = not )
    assert( 8 0 ^ 1 = )
    assert( 8 1 ^ 8 = )
    assert( 8 2 ^ 64 = )
;

:test
    100 stash
    [char] X stash
    assert( unstash [char] X = )
    assert( unstash 100 = )
;
