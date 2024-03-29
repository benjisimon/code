\ test out character logic

:test
    assert( [char] X uppercase-char? )
    assert( [char] x uppercase-char? not )
    assert( [char] X word-char? )
    assert( [char] ' word-char? )
    assert( [char] - word-char? )
    assert( [char] # word-char? not )
    assert( [char] _ word-char? not )
    assert( [char] # non-word-char? )
    assert( 0 non-word-char? not )
    assert( 0 word-char? not )
;