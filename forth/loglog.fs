\ Implement Loglog algorith from the
\ programming praxis exercise

require lib/modules.fs
require lib/utils.fs
require lib/bits.fs
require lib/strings.fs
require lib/random.fs
require lib/testing.fs
require lib/hashing.fs

require tests/modules.fs
require tests/utils.fs
require tests/bits.fs
require tests/random.fs
require tests/hashing.fs

cr run-all cr cr

s" foo bar gaz" cstring xxx

: random-words ( -- )
    50 0 +do
        random-word 2dup type space space hash . cr
    loop ;

random-words