\ library to work with a collection of cards,
\ known as a deck

require utils.fs
require modules.fs
require cards.fs

module

52 constant deck#
deck# 2 / constant deck#/2
deck# 2 * constant deck#*2


:private fill-it ( deck -- deck )
    deck# 0 +do
        i ,
    loop ;

: new-deck ( -- deck ) here fill-it ;

: peek ( n deck -- nth-card )
    swap cells + @ ;

: replace ( new-card position deck -  )
    swap cells + ! ;

    

: .deck ( deck -- )
    cr
    deck# 0 +do
        i 13 mod 0 = i >0 and if cr then
        bl emit
        dup i swap peek .card
    loop ;

publish
