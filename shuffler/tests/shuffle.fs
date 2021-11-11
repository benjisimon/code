\ test out shuffle functionality

s" ../shuffle.fs" required

randomize

: core
    new-deck shuffle .deck
    cr
    new-deck 7*shuffle .deck
    cr
;

create 5th-card
: 5th-test
    10 0 +do
        new-deck 7*shuffle 5 swap peek 5th-card i cells + ! 
    loop ;

: 5th-results
    cr
    10 0 +do
        5th-card i cells + @ .
    loop  cr ; 


5th-test 5th-results


: privacy
    assert( s" shuffler" find-name 0 =  )
;

privacy core