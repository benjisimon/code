\ tools to automate unit testing

private-words

200 constant #max-tests
here constant all-tests
#max-tests cells allot
variable #tests
0 #tests !

: register-test ( xt -- )
    assert( #tests @  #max-tests < )
    #tests @ cells all-tests + !
    #tests ++! ;

: nth-test ( n -- xt )
    cells all-tests + @ ;

: .test-outcome ( error-code -- )
    dup =0 if ." OK" else  ."  ( " . ." )"  then ;
    
public-words

: :test ( -- ) : latestxt register-test ;

: run-all ( -- )
    #tests @ 0 +do
        cr i nth-test >name .name ." : "
        i nth-test catch
        .test-outcome
    loop ;

publish