\ tools to automate unit testing

module

private-words

200 constant #max-tests
create all-tests 
#max-tests cells allot

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
    cells all-tests + ;

: num-tests ( -- n )
    #tests @ ;

:private current-test ( -- test-record )
    num-tests nth-test ;


:private register-test ( xt -- )
    assert( num-tests #max-tests < )
    current-test !
    #tests @+1! ;

: :test ( -- ) noname : latestxt register-test ;

: run-tests ( -- )
    reset-stats
    #tests @ 0  +do
        i nth-test @ catch
        track-outcome
        clearstack
    loop
    .stats ;

publish