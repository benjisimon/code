\ linked lists

module

private-words

create eol-marker

: eol? ( n -- bool )
    eol-marker = ;

public-words

create null

: null? ( something -- bool )
    null = ;


: list? ( n -- bool ) recursive
    dup null? if
        drop true
    else 
        dup cons? if
            cdr list?
        else
            drop false
        then
    then ;

: << eol-marker ;

: >> ( end-of-list-marker item ... -- list )
    null
    begin
        over eol? not
    while
            cons
    repeat nip ;


: fold recursive { xt list -- } 
    list null? not if
        list car xt execute
        xt list cdr fold
    then ;

: map recursive { xt list -- }
    list null? if
        null
    else
        list car xt execute
        xt list cdr map
        cons
    then ;

: list. recursive ( list -- )
    assert( dup list? )
    ." << "
    begin
        dup null? not
    while
            uncons swap
            dup list? if
                list.
            else
                .
            then
    repeat drop
    ." >> " ;

publish