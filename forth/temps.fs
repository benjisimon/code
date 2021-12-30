\ temperature example, useful for demostrating modules & tests

require lib/modules.fs
require lib/utils.fs
require lib/testing.fs
require lib/temps.fs

require tests/utils.fs
require tests/modules.fs
require tests/temps.fs

run-all

: tab ( -- )
    5 0 u+do space loop ;

10 constant chart-incr

: f-chart. ( low high -- )
    chart-incr + swap u+do
        cr i deg-f
        dup deg-f. tab
        dup deg-c. tab
        deg-k.
    chart-incr +loop cr ;

