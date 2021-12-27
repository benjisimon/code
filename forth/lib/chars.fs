\ library for worknig with characters

module


: uppercase-char? { c -- flag }
    [char] A [char] Z c between? ;

: lowercase-char? { c -- flag }
    [char] a [char] z c between? ;

: numeric-char? { c -- flag }
    [char] 0 [char] 9 c between? ;

: word-char? { c -- flag }
    c uppercase-char?
    c lowercase-char? or
    c [char] ' =
    c [char] - = or or ;

publish