\ crude impl of modules

: +++ ( -- )
    get-order >r
    over set-current
    r> set-order ;
    
: --- ( -- )
    get-order >r
    dup set-current
    r> set-order ;
    
: module ( )
    wordlist >order ( public )
    wordlist >order ( private ) ;

: publish ( )
    previous ;
