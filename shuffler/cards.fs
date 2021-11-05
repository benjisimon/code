\ library for working with play cards


4 constant #suites
13 constant #ranks

: suit ( card -- suit )
    #ranks / ;

: rank ( card -- rank )
    #ranks mod ;

