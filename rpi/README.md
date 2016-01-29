Raspberry Pi Hacking

Examples:

for i in `seq 1 10`; do v=`expr $i % 2`; echo $v > /sys/class/gpio/gpio17/value ; sleep .5 ; done

while true ; do ./blink 1 1 ; done

while true ; do ./blink .5 .5 .25 .25 .5 .5 ; done

./led on
while true ; do ./led on ; sleep .25 ; ./led off ; sleep .25 ; done
while true ; do ./led on ; sleep .25 ; ./led off ; sleep .25 ; done
