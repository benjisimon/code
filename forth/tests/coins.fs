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

create #heads 0 ,
create #tails 0 ,

: close-enough? ( x y -- b )
    - abs 30 < ;


:test
    assert( #heads @ 0 = )
    assert( #tails @ 0 = )

    100 0 +do
        flip
        heads? if #heads else #tails endif @+1!
    loop

    assert( #heads @  #tails @ close-enough? )
    
;

