\ another very simple random number generator
\ via: https://computer.howstuffworks.com/question697.htm

module

defer rand

private-words

8961243219 constant seed-init
variable seed
seed-init seed !


: simple-seed-src ( -- )
    seed @ 110315245 * 12345 +
    dup seed !
    65536 / 32768 mod ;

: simple-seed-rand ( -- )
    1
    simple-seed-src 4 mod 1+ 0 +do
        simple-seed-src *
    loop ;

s" /dev/urandom" r/o open-file throw constant /dev/urandom-fd

create /dev/urandom-buffer 1 cells allot
: /dev/urnadom-rand ( -- u )
    /dev/urandom-buffer 1 cells /dev/urandom-fd read-file throw
    assert( 1 cells = )
    /dev/urandom-buffer @ ;

' simple-seed-rand is rand

public-words



: randomize ( -- )
    ['] /dev/urnadom-rand is rand ;

: unrandomize ( -- )
    ['] simple-seed-rand is rand
    seed-init seed ! ;

: random ( max -- rand )
    rand swap mod ;

private-words

s" /usr/share/dict/words" cstring words-path
256 constant max-line
create line-buffer max-line 2 + allot

public-words

: random-seek { fd -- }
    fd file-size throw d>s random s>d
    fd reposition-file  ;

: random-word ( -- c-addr u )
    words-path r/o open-file throw { fd }
    fd random-seek throw
    line-buffer max-line fd read-line throw drop drop 
    line-buffer max-line fd read-line throw drop line-buffer swap
    fd close-file throw ;

publish