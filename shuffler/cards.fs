\ library for working with play cards


4 constant #suites
13 constant #ranks

: suit ( card -- suit )
    #ranks / ;

: rank ( card -- rank )
    #ranks mod ;

create suit-symbols char H c, char C c,  char S c, char D c,

: suit>sym ( suit -- c )
    suit-symbols + c@ ;
