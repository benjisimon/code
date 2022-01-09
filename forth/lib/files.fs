\ work with files

module


private-words

create char-buffer 1 char allot
80 constant max-word-length
create word-buffer max-word-length allot
0 value word-buffer-posn

public-words

:private init-buffer ( -- )
    0 to word-buffer-posn ;

:private append-to-buffer ( c -- )
    word-buffer word-buffer-posn + c!
    word-buffer-posn 1+ to word-buffer-posn ;


:private eof? ( x -- eof? )
    0 = ;

: file-has-char? ( wfileid -- bool )
    dup file-position throw d>s swap
    file-size throw d>s < ;

: file-read-char { wfileid -- char }
    wfileid file-has-char? if
        char-buffer 1 wfileid read-file throw drop
        char-buffer c@
    else
        0
    then ;

: file-peek-char { wfileid -- char }
    wfileid file-has-char? if
        wfileid file-position throw d>s { before }
        wfileid file-read-char { c }
        before  s>d wfileid reposition-file throw
        c
    else
        0
    then ;

private-words

200 string-buffer seq-buffer

public-words

: read-sequence { xt wfileid -- c-addr count }
    sb-reset seq-buffer 
    begin
        wfileid file-peek-char
        xt execute  while
            wfileid file-read-char sb-append seq-buffer
    repeat
    sb-value seq-buffer ;

: read-word ( wfileid -- c-addr count )
    ['] non-word-char? over read-sequence   2drop 
    ['] word-char? swap read-sequence ;
    
publish