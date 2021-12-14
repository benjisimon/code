\ utilities for working with strings

module

: cstring ( c-addr u -- )
    create , ,
  does> ( cstring -- c-addr u )
    dup 1 cells + @ swap @ ;

publish 