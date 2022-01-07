\ Test out files

module

private-words

s" data/short.txt" r/o open-file throw value short-fd

:test
    assert( short-fd file-peek-char [char] L = )
    assert( short-fd file-peek-char [char] L = )
    assert( short-fd file-read-char [char] L = )
    assert( short-fd file-peek-char [char] a = )
    assert( short-fd file-peek-char [char] a = )
    assert( short-fd file-read-char [char] a = )
;

publish