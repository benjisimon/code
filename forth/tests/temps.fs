
:test
    assert( 9 deg-c 900 = )
    assert( 52 deg-f 1111 = )
    assert( 3838 deg-k 356485 = )
;

:test
    assert( 99 dup deg-c as-deg-c = )
    assert( 99 dup deg-f as-deg-f = )
    assert( 99 dup deg-k as-deg-k = )
;

:test
    assert( 99 deg-c as-deg-f 210 = )
    assert( 99 deg-f as-deg-c 37 = )
    assert( 99 deg-k as-deg-c -174 = )
;