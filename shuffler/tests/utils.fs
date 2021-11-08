\ test out utils

s" ../utils.fs" required

create foo 0 ,

: memory
    assert( foo @ 0 = )
    foo ++!
    assert( foo @ 1 = ) ;

: logic
    assert( 1 1 + 3 = not )
    assert( 1 1 + 2 = not not ) ;

memory logic