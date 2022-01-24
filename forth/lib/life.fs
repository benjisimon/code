\ implement conway's game of life

module


0 value x
0 value y

: posn! ( x y -- )
    to y
    to x ;

private-words

1 constant alive
0 constant dead 
0 value width
0 value height
0 value grid
0 value generation

defer walk-op ( ... -- ... )


: gen-offset ( generation -- offset-into-grid )
    2 mod width height * * ;

: normalize { val max -- val }
    val max + max mod ;

: walk ( ... -- ... )
    height 0 +do
        width 0 +do
            i to x
            j to y
            walk-op
        loop
    loop ;

: >cell { x y generation -- cell }
    generation gen-offset
    y height normalize width * +
    x width normalize + cells
    grid + ;

public-words

: alive? ( -- boolean )
    x y generation >cell @ alive = ;

: #living-neighbors ( -- num-alive )
    0
    2 -1 +do
        2 -1 +do
            i 0 = j 0 = and not if
                x i +
                y j + generation  >cell @ +
            then
        loop
    loop ;

: supported? ( -- boolean )
    #living-neighbors dup
    2 = swap
    3 = or ;

: >dimensions ( x y -- )
    to height
    to width
    here to grid
    width height * 2 * cells allot
    0 to generation ;

:private init ( cell-init-state -- )
    width 1- x -
    height 1- y -
    generation >cell ! ;

: start ( init-state ... -- )
    ['] init is walk-op
    walk ;


:private evolve-cell ( -- )
    alive? if
        supported? if alive else dead then
    else
        supported? if alive else dead then
    then
    x y generation 1+ >cell ! ;
    
: evolve ( -- )
    ['] evolve-cell is walk-op
    walk
    generation 1+ to generation ;

:private eol? ( -- )
    x width 1 - = ;

:private .cell ( -- )
    x y generation >cell ?
    eol? if cr then ;

: .grid
    ['] .cell is walk-op
    walk ;
    

    