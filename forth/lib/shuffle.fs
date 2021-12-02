\ Forth shuffle impl.

module

private-words


here constant shuffler deck#*2 cells allot
variable arm
variable being-shuffled

public-words

:private init ( deck -- )
    being-shuffled !
    0 arm ! ;

:private load ( -- )
    deck# 0 +do
        i being-shuffled @ peek
        i cells shuffler + !
    loop

    deck# 0 +do 
        false deck# i + cells shuffler + !
    loop ;


:private unload ( -- ) 
    deck# 0 +do
        deck# i + cells shuffler + @ 
        i being-shuffled @ replace
    loop ;

:private destroy ( -- deck )
    being-shuffled @
    0 being-shuffled ! ;

:private crank ( -- )
    shuffler arm @ cells + @
    shuffler arm @ deck#/2 + cells + @
    flip heads? if swap then
    shuffler deck# arm @ 2 * + cells + !
    shuffler deck# arm @ 2 * + 1 + cells + !
    1 arm +!
;

: shuffle ( deck -- deck )
    init load
    deck#/2 0 +do crank loop
    unload destroy ;
    
    
: *shuffle ( deck n-times -- deck )
    0 +do shuffle loop ;

: 7*shuffle  ( deck -- deck )
    7 *shuffle ;

publish