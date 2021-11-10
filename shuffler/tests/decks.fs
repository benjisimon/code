\ test out decks

s" ../decks.fs" required

: core
    assert( deck# 52 = )
    assert( deck#/2 52 2 / = )
    assert( deck#*2 52 2 * = )
;


new-deck constant d1


: more 
    assert( d1 @ 0 = )
    assert( 1 d1 peek 1 = )
    assert( 15 d1 peek 15 = )
;

: print
    new-deck .deck 
;



core more print