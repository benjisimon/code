\ tools to automate unit testing

module

public-words

struct
    cell% field test-xt
    cell% field test-name-length
    cell% field test-name-addr
    cell% field test-line
end-struct test%

private-words

200 constant #max-tests
create all-tests 
#max-tests test% %size * allot

variable #tests
0 #tests !

variable #passes
variable #fails

: reset-stats ( -- )
    0 #passes !
    0 #fails ! ;

: track-outcome ( outcome -- )
    0 = if #passes else #fails then @+1! ;

: .stats ( -- )
    #passes @ #fails @ + . ." Tests Run, "
    #passes ? ." Passed, "
     #fails ? ." Failed";

public-words

: nth-test ( n -- test-record )
    test% %size * all-tests + ;

: num-tests ( -- n )
    #tests @ ;

: test-name ( test-record -- c-addr u )
    dup test-name-addr @
    swap test-name-length @ ;

private-words

: current-test ( -- test-record )
    num-tests nth-test ;


: register-test ( xt -- )
    assert( num-tests #max-tests < )
    current-test test-xt  !
    sourcefilename current-test test-name-length !
    current-test test-name-addr !
    sourceline# current-test test-line !
    #tests @+1! ;



: .test-outcome ( error-code -- )
    dup =0 if ." OK" drop else  ."  ( " . ." )"  then ;

: .test-name ( test -- )
    dup test-name type
    ." :" 
    test-line @ . ;


public-words

: :test ( -- ) noname : latestxt register-test ;

: run-all ( -- )
    reset-stats
    #tests @ 0  +do
        i nth-test test-xt @ catch
        track-outcome
        clearstack
    loop
    .stats ;

publish