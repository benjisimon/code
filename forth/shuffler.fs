\ Main include file for the project

require random.fs


require lib/modules.fs
require lib/utils.fs
require lib/testing.fs
require lib/coins.fs
require lib/cards.fs
require lib/decks.fs
require lib/shuffle.fs  

require tests/utils.fs 
require tests/modules.fs
require tests/cards.fs
require tests/coins.fs
require tests/decks.fs
require tests/shuffle.fs 

cr run-all cr cr
new-deck shuffle .deck  cr
new-deck 7*shuffle .deck cr cr


