\ Implement scheme style cons

module

: cons ( car cdr -- cons-addr )
    here stash
    , ,
    unstash ;

: car ( cons-addr -- car )
    1 cells + @ ;

: cdr ( cons-addr -- cdr )
    @ ;

: set-car! ( car cons-addr -- )
    1 cells + ! ;

: set-cdr! ( cdr cons-addr -- )
    ! ;


publish