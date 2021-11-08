\ crude impl of modules

: public-mode ( -- )
    get-order >r
    over set-current
    r> set-order ;
    
: private-mode ( -- )
    get-order >r
    dup set-current
    r> set-order ;


: :private private-mode : public-mode ;

: module ( )
    wordlist >order ( public )
    wordlist >order ( private )
    public-mode ;

: publish ( )
    previous ;
