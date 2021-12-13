\ Hashing impl

module

private-words

variable h

: hash-init ( -- )
    5381 h ! ;

: hash-value ( -- h  )
    h c@ ;

: hash-update ( h -- )
    h ! ;

: hash-char ( c -- )
    hash-value 5 << hash-value + +
    hash-update ;


public-words

: hash ( c-addr length -- hash )
    hash-init
    0 +do
        dup i + @ hash-char
    loop
    drop hash-value ;

publish
