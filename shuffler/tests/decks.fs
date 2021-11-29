\ test out decks

s" ../project.fs" required

:test
    assert( deck# 52 = )
    assert( deck#/2 52 2 / = )
    assert( deck#*2 52 2 * = )
;


new-deck constant d1


:test 
    assert( d1 @ 0 = )
    assert( 1 d1 peek 1 = )
    assert( 15 d1 peek 15 = )

    deck#/2 0 +do
        15 i d1 replace
    loop

    deck#/2 0 +do
        i d1 peek dup
        assert( suit suit>sym [char] C = )
        assert( rank rank>sym [char] 3 = )
    loop
;

:test
    cr cr
    ." Half Replaced: "
    d1 .deck
    cr cr
    ." Fresh Deck: "
    new-deck .deck
    cr cr
;
