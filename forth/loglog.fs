\ Implement Loglog algorith from the
\ programming praxis exercise

require lib/modules.fs
require lib/utils.fs
require lib/bits.fs
require lib/chars.fs
require lib/strings.fs
require lib/files.fs
require lib/random.fs
require lib/testing.fs
require lib/hashing.fs
require lib/arrays.fs

require tests/modules.fs
require tests/utils.fs
require tests/bits.fs
require tests/random.fs
require tests/chars.fs
require tests/hashing.fs
require tests/arrays.fs
require tests/files.fs
require tests/strings.fs

cr run-all cr cr

s" data/macbeth.txt" r/o open-file throw value macbeth-fd
s" data/short.txt" r/o open-file throw value short-fd




: next-word ( -- c-addr u | 0 )
    macbeth-fd read-word ;

: eof? ( x -- b )
    0 = ;

: collect-stats ( -- )
    begin
        next-word dup eof? not while
            type
    repeat ;

