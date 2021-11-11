\ test out shuffle functionality

s" ../shuffle.fs" required

randomize

: core
    new-deck
    20 0 +do
        shuffle
    loop  .deck ;

: privacy
    assert( s" shuffler" find-name 0 =  )
;

core privacy