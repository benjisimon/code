\ Test out files

module

private-words

s" data/short.txt" r/o open-file throw value short-fd

:test
    assert( ['] word-char?     short-fd read-sequence s" Larry" str= )
    assert( ['] non-word-char? short-fd read-sequence s" , " str= )
    assert( ['] word-char?     short-fd read-sequence s" Curly" str= )
;

:test
    0 s>d short-fd reposition-file throw
    assert( short-fd file-peek-char [char] L = )
    assert( short-fd file-peek-char [char] L = )
    assert( short-fd file-read-char [char] L = )
    assert( short-fd file-peek-char [char] a = )
    assert( short-fd file-peek-char [char] a = )
    assert( short-fd file-read-char [char] a = )
;

: test
    0 s>d short-fd reposition-file throw
    assert( short-fd read-word s" Larry" str= )
    assert( short-fd read-word s" Curly" str= )
    assert( short-fd read-word s" AND" str= )
    assert( short-fd read-word s" Moe" str= )
;





publish