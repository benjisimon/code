\ Test out arrays

module

private-words

10 constant #boxes
#boxes array boxes


:test
    assert(  array-length boxes #boxes  = )
    37 array-fill boxes
    #boxes 0 +do
        assert( i boxes @  37 = )
    loop
;

:test
    27 array-fill boxes
    97 3 boxes !
    2 9 boxes !
    assert( 1000 ['] min array-values boxes 2 = )
    assert( 0 ['] max array-values boxes 97 = )
;

publish
