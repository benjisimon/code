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

: randomize ( -- )
    utime drop seed ! ;

: unrandomize ( -- )
    seed-init seed ! ;

: random ( max -- rand )
    rand swap mod ;

publish