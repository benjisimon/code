\ another very simple random number generator
\ via: https://computer.howstuffworks.com/question697.htm

module

private-words

8961243219 constant seed-init
variable seed
seed-init seed !

public-words


: rand ( -- )
    seed @ 110315245 * 12345 +
    dup seed !
    65536 / 32768 mod ;

: rand ( -- )
    1
    rand 4 mod 1+ 0 +do
        rand *
    loop ;

: randomize ( -- )
    utime drop seed ! ;

: unrandomize ( -- )
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
    fd random-seek
    line-buffer max-line fd read-line throw drop drop 
    line-buffer max-line fd read-line throw drop line-buffer swap ;

publish