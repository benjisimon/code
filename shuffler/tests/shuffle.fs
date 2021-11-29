\ test out shuffle functionality

s" ../project.fs" required

randomize

:test
    new-deck shuffle .deck
    cr
    new-deck 7*shuffle .deck
    cr
;

:test
    assert( s" shuffler" find-name 0 =  )
;

