\ test out bits

:test
    assert( %11110001111 1935 = )
    assert( 3 bit-mask %100 = )
    assert( 3 bit-mask 5 bit-mask or %10100 = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 5 bit-on? false = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 5 bit-on 5 bit-on? true = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 4 bit-on? false = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 3 bit-on? true = )
;

: *33 ( x -- x*33 )
    dup 5 << + ;

:test
    assert( 1 0 << 1 = )
    assert( 1 5 << 32 = )
    assert( 1 *33 33 = )
    assert( 94948 *33 94948 33 * = )
    ;