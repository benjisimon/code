\ crude impl of modules

: public-words ( -- )
    get-order >r
    over set-current
    r> set-order ;
    
: private-words ( -- )
    get-order >r
    dup set-current
    r> set-order ;


: :private private-words : public-words ;

: module ( )
    wordlist >order ( public )
    wordlist >order ( private )
    public-words ;

: publish ( )
    previous ;
