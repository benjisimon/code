\ catalog of unit tests
require project.fs

:test foo ( -- )
assert( true ) ;

:test bar ( -- )
assert( false ) ;

:test baz ( -- )
assert( true ) ;

run-all
