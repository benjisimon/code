\ Implement Loglog algorith from the
\ programming praxis exercise

require lib/modules.fs
require lib/utils.fs
require lib/bits.fs
require lib/chars.fs
require lib/strings.fs
require lib/files.fs
require lib/random.fs
require lib/arrays.fs
require lib/testing.fs
require lib/hashing.fs


require tests/modules.fs
require tests/utils.fs
require tests/bits.fs
require tests/random.fs
require tests/chars.fs
require tests/hashing.fs
require tests/arrays.fs
require tests/files.fs
require tests/strings.fs

cr run-tests cr cr

s" data/macbeth.txt" r/o open-file throw value macbeth-fd
s" data/short.txt" r/o open-file throw value short-fd



: next-word ( -- c-addr u | 0 )
    macbeth-fd read-word ;

: eof? ( x -- b )
    0 = ;

0 value #words

: #words++ ( -- )
    #words 1+ to #words ;

15 array buckets
0 array-fill buckets

: analyze-bits { h i bucket -- hash }
    h i lsb? 1 and bucket @+!
    h ;
    

: analyze-hash ( hash -- )
    ['] analyze-bits array-each buckets ;

: collect-stats ( -- )
    begin
        next-word dup eof? not while
            hash analyze-hash drop #words++
    repeat ;

: bucket. ( i bucket -- )
    swap dup . lsb bin. ." : " @ dup . ."  ( " #words t% . ." %)" cr ; 
    

: stats. ( -- )
    ." # Words w/ Prefix" cr
    [']  bucket. array-each buckets ;
