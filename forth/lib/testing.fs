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

public-words

:private reset-stats ( -- )
    0 #passes !
    0 #fails ! ;

:private track-outcome ( outcome -- )
    0 = if #passes else #fails then @+1! ;

:private .stats ( -- )
    #passes @ #fails @ + . ." Tests Run, "
    #passes ? ." Passed, "
     #fails ? ." Failed";

: nth-test ( n -- test-record )
    test% %size * all-tests + ;

: num-tests ( -- n )
    #tests @ ;

:private test-name ( test-record -- c-addr u )
    dup test-name-addr @
    swap test-name-length @ ;


:private current-test ( -- test-record )
    num-tests nth-test ;


:private register-test ( xt -- )
    assert( num-tests #max-tests < )
    current-test test-xt  !
    sourcefilename current-test test-name-length !
    current-test test-name-addr !
    sourceline# current-test test-line !
    #tests @+1! ;

:private .test-outcome ( error-code -- )
    dup =0 if ." OK" drop else  ."  ( " . ." )"  then ;

:private .test-name ( test -- )
    dup test-name type
    ." :" 
    test-line @ . ;

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