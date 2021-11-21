\ tools to automate unit testing

private-words

0 cells               constant xt-offset
xt-offset 2 cells +   constant name-offset
name-offset 1 cells + constant line-offset
4 cells constant record-size

200 constant #max-tests
create all-tests
#max-tests record-size * allot

variable #tests
0 #tests !

: xt@ ( test-record -- xt )
    xt-offset + @ ;

: name@ ( test-record -- c-addr n )
    dup name-offset + @ stash
    name-offset 1 cells + @ unstash ;

: line@ ( test-record -- line )
    name-offset + @ ;

: xt! ( xt test-record -- )
    xt-offset + ! ;

: name! ( c-addr n test-record -- )
    stash swap unstash ( n c-addr test-record )
    name-offset + dup stash !
    unstash 1 cells + ! ;

: line! ( line-number test-record -- )
    line-offset + ! ;

: current-test-addr ( -- test-record )
    all-tests #tests 1 - record-size * + ;

: register-test ( xt -- )
    assert( #tests @  #max-tests < )
    current-test-addr xt!
    sourcefilename current-test-addr name!
    sourceline current-test-addr line!
    #tests ++! ;

: nth-test ( n -- xt )
    cells all-tests + @ ;

: .test-outcome ( error-code -- )
    \ XXX: prefix: sourcefilename 
    dup =0 if ." OK" else  ."  ( " . ." )"  then ;
    
public-words

: :test ( -- ) :noname latestxt register-test ;

: run-all ( -- )
    #tests @ 0 +do
        cr ." : "
        i nth-test catch
        .test-outcome
    loop ;

publish