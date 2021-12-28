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
require lib/cons.fs
require lib/lists.fs

require tests/modules.fs
require tests/utils.fs
require tests/bits.fs
require tests/random.fs
require tests/chars.fs
require tests/hashing.fs
require tests/cons.fs
require tests/lists.fs

cr run-all cr cr

s" data/macbeth.txt" r/o open-file throw value macbeth-fd

: next-word ( -- c-addr u | 0 )
    macbeth-fd read-word ;

: max-hash ( -- n )
    0
    1000 0 +do
        random-word hash max
    loop ;