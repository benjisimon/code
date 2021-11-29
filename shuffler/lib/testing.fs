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
    \ XXX: prefix: sourcefilename 
    dup =0 if ." OK" drop else  ."  ( " . ." )"  then ;

: .test-name ( test -- )
    dup test-name type
    ." :" 
    test-line @ . ;


public-words

: :test ( -- ) noname : latestxt register-test ;

: run-all ( -- )
    #tests @ 0  +do
        cr i nth-test .test-name
        ." : "
        i nth-test test-xt @ catch
        .test-outcome
    loop ;

publish