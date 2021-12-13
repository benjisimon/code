\ test out hour hashing libary

:test ( -- )
    assert( s" Hello World" hash 129 = )
    assert( s" Good Bye World" hash 246 = )
    assert( s" hello world" hash 193 = )
;
    