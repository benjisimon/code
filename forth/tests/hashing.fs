\ test out hour hashing libary

:test ( -- )
    assert( s" Hello World" hash $BFE6210387781081 = )
    assert( s" Hello world" hash $BFE6210389BB20A1 = )
    assert( s" Hello World" hash $BFE6210387781081 = )
;
    