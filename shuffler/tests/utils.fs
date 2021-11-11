\ test out utils

s" ../utils.fs" required

create foo 0 ,

: memory
    assert( foo @ 0 = )
    foo ++!
    assert( foo @ 1 = ) ;

: logic
    assert( 1 1 + 3 = not )
    assert( 1 1 + 2 = not not )
    assert( 10 >0 )
    assert( 0 >0 not )
    assert( 3 odd? )
    assert( 383837721 odd? )
    assert( 383732 odd? not )
;

: math
    assert( 100 random 0 = )
    assert( 100 random 0 = )
    assert( 100 random 0 = )
    assert( 100 random 17 = )
    randomize
    assert( 100 random 78 = not )
;

memory logic math