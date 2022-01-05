\ Test out files

module

private-words

s" data/short.txt" r/o open-file throw value short-fd

:test
    assert( short-fd read-word s" Larry" str= )
    assert( short-fd read-word s" Curly" str= )
    assert( short-fd read-word s" AND" str= )
    assert( short-fd read-word s" Moe" str= )
;

publish