\ tools to automate unit testing

module

0 value #tests
400 array tests
0 array-fill tests

private-words

array-length tests array src-addrs
array-length tests array src-counts
array-length tests array src-lines
array-length tests array outcomes

: register-test ( xt -- )
    #tests tests !
    sourcefilename #tests src-counts ! #tests src-addrs !
    sourceline# #tests src-lines !
    #tests 1+ to #tests ;

: .test { i -- }
    i src-addrs @ i src-counts @ type
    ." :"  i src-lines @  . ;
    
: pass? ( outcome -- 0|1 )
    0 = 1 and ;

: failure? ( outcome -- 0|1 )
    pass? not 1 and ;

: any? ( outcome -- 1)
    drop 1 ;

: .outcome ( outcome -- )
    dup pass? if
        drop ." OK"
    else
        ." Fail: " .
    then ;

: .details { filter-xt -- }
    #tests 0 +do
        i outcomes @ filter-xt execute if
            i . ."  " 
            i outcomes @ .outcome ."  " i .test cr
        then
    loop ;

: .summary ( -- )
    0
    #tests 0 +do
        i outcomes @ failure? +
    loop
    . ." Failures, " #tests . ." Tests" cr ;



public-words

  
: :test ( -- ) noname : latestxt register-test ;

: run-test ( n -- )
    tests @ catch .outcome ;

: tests. ( -- )
    ['] any? .details ;

: tests.failures ( -- )
    ['] failure? .details ;

: run-tests ( -- )
    #tests 0 +do
        i tests @ catch i outcomes !
    loop .summary ;

publish