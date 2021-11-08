\ test out our modules

s" ../modules.fs" required
s" ../utils.fs" required

module

+++

: x 100 ;
  

---

: y 200 ;

+++

: z 300 x * ;

publish

: core
    assert( x 100 = )
    assert( x z + 30100 = )
    assert( s" x" find-name 0 = not )
    assert( s" y" find-name 0 = )
;

core
  

  
