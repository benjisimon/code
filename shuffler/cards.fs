\ library for working with play cards

require project.fs

module

4 constant #suites
13 constant #ranks

: suit ( card -- suit )
    #ranks / ;

: rank ( card -- rank )
    #ranks mod ;

create suit-symbols char H c, char C c,  char S c, char D c,

: suit>sym ( suit -- c )
    suit-symbols + c@ ;

create rank-symbols char A c, char 2 c, char 3 c,
char 4 c, char 5 c, char 6 c, char 7 c, char 8 c,
char 9 c, char X c, char J c, char Q c, char K c,


: rank>sym ( rank -- c )
    rank-symbols + c@ ;

: blank ( -- b )
    -1 ;

: blank? ( c -- t|f )
    blank = ;

: .blank ( b -- )
    [char] _ emit
    [char] _ emit ;


: .card ( card -- )
    dup suit suit>sym
    swap rank rank>sym
    emit emit ;

: .card ( card -- )
    dup blank? if .blank else .card then ;



publish
