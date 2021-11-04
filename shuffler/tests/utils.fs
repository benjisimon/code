\ test out utils

s" ../utils.fs" required

create foo 0 ,

: memory
    assert( foo @ 0 = )
    foo ++!
    assert( foo @ 1 = )
;

memory