\ test out utils

create foo 0 ,

:test
    assert( foo @ 0 = )
    foo @+1!
    assert( foo @ 1 = )
    0 foo !
    assert( foo @ 0 = ) ;

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
    100 stash
    [char] X stash
    assert( unstash [char] X = )
    assert( unstash 100 = )
    1001 stash
    assert( clash 1001 = )
    assert( clash 1001 = )
    assert( unstash 1001 = )
;

:test
    assert( 0 100 0 between? )
    assert( 0 100 50 between? )
    assert( 0 100 100 between? )
    assert( 0 100 101 between? not )
    assert( 0 100 999 between? not )
;

:test
    assert( s" foo/" s" bar/" str+ s" foo/bar/" str= )
    assert( s" foo/" s" bar/" +str s" bar/foo/" str= )
;