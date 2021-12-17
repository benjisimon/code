\ Implement scheme style cons

module

private-words

here constant cons-marker

public-words

: cons ( car cdr -- cons-addr )
    here { h }
    cons-marker ,
    , ,
    h ;

: car ( cons-addr -- car )
    2 cells + @ ;

: cdr ( cons-addr -- cdr )
    1 cells + @ ;

: set-car! ( car cons-addr -- )
    2 cells + ! ;

: set-cdr! ( cdr cons-addr -- )
    1 cells + ! ;

: cons? ( any -- bool )
    ['] @ catch
    =0 if
        cons-marker =
    else
        drop false
    then ;

publish