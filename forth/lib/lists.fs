\ linked lists

module

private-words

create eol-marker

: eol? ( n -- bool )
    eol-marker = ;

public-words

0 constant null

: null? ( something -- bool )
    null = ;


:private cons-based-list? ( n -- bool ) recursive
    dup cons? if
        cdr null? if
            true
        else
            cons-based-list?
        then
    else
        drop false
    then ;

: list? ( something -- bool )
    dup null?
    swap cons-based-list? or ;

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

publish