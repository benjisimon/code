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

: read-char { wfileid -- char }
    char-buffer 1 wfileid read-file throw 1 = if
        char-buffer c@
    else
        0
    then ;
    
    
:private slurp-whitespace ( wfileid -- char | 0 )
    begin
        dup read-char dup word-char? not
    while
            drop
    repeat ;

:private slurp-text { wfileid c -- c-addr count }
    init-buffer
    c 0 = if
    else
        c append-to-buffer
        begin
            wfileid read-char dup word-char?
        while
                append-to-buffer
        repeat drop
    then
    word-buffer word-buffer-posn ;
            
: read-word ( wfileid -- c-addr count )
    dup slurp-whitespace 
    slurp-text ;
    
publish