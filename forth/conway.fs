\ The game of life. Why not.
\
\ Rules
\ Any live cell with two or three live neighbours survives.
\ Any dead cell with three live neighbours becomes a live cell.
\ All other live cells die in the next generation. Similarly, all other dead cells stay dead.
\

require lib/modules.fs
require lib/utils.fs
require lib/arrays.fs
require lib/testing.fs

lib modules
lib utils
lib arrays
lib life

run-tests cr cr



