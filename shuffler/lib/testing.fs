\ tools to automate unit testing

private-words

200 constant #max-tests
here constant all-tests
#max-tests cells allot
variable #tests
0 #tests !

: register-test ( xt -- )
    assert( #tests @  #max-tests < )
    cr ." Registering a test" dup >name drop .name cr
    all-tests !
    #tests ++! ;

: nth-test ( n -- xt )
    cells all-tests + @ ;

public-words

: :test ( -- ) : latestxt register-test ;

: run-all ( -- )
    #tests @ 0 0 +do
        i nth-test >name .name ." :"
        try
            i nth-test execute
            ." OK"
            iferror
                ." Fail"
            endif
        endtry
        cr
    loop ;

publish