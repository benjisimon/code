\ test out bits

:test
    assert( %11110001111 1935 = )
    assert( 3 bit-mask %100 = )
    assert( 3 bit-mask 5 bit-mask or %10100 = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 5 bit-on? false = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 4 bit-on? false = )
    assert( 3 bit-mask 5 bit-mask or 5 bit-off 3 bit-on? true = )
;