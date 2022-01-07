\ test out strings

module

private-words

26 string-buffer letters

:test
    assert( sb-length letters 26 = )
    assert( sb-position letters 0 =  )
    [char] X sb-fill letters 
    assert( 0 letters c@ [char] X = )
    assert( 13 letters c@ [char] X = )
    [char] F 15 letters c!
    assert( 15 letters c@ [char] F = )
;

:test
    bl sb-reset letters
    assert( sb-position letters 0 = )
    [char] H sb-append letters
    [char] e sb-append letters
    [char] l sb-append letters
    [char] l sb-append letters
    [char] o sb-append letters
    assert( sb-position letters 5 = )
    assert( s" Hello" sb-value letters str= )
;

publish