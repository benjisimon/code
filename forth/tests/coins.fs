\ test out coin.fs

:test
    assert( heads heads? )
    assert( tails tails? )
    assert( heads tails? false  = )
    assert( heads coin? )
    assert( tails coin? )
    assert( 100 coin? false = )
    assert( flip coin? )
;

0 value #heads
0 value #tails

: close-enough? ( x y -- b )
    - abs 30 < ;


:test
    randomize
    0 to #heads
    0 to #tails
    assert( #heads 0 = )
    assert( #tails 0 = )

    100 0 +do
        flip
        heads? if 1 0 else 0 1 endif
        #tails + to #tails
        #heads + to #heads
    loop

    assert( #heads  #tails close-enough? )
;
