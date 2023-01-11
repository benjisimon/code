##
## Shows how long the car has been turned on for
##

import time
import board
import terminalio
from adafruit_display_text import bitmap_label

scale = 5

started = time.monotonic();
text_area = bitmap_label.Label(terminalio.FONT, text="---", scale=scale)
text_area.x = 0
text_area.y = 60
board.DISPLAY.show(text_area)

def digit(value):
    return str(value) if value > 10 else "0" + str(value)

def time_string(started):
    now = time.monotonic()
    t = round(now - started)
    ss = t % 60
    mm = (t // 60) % 60
    hh = (t // (60*60)) % 60
    return digit(hh) + ":" + digit(mm) + ":" + digit(ss)


while True:
    text_area.text = time_string(started)
    time.sleep(1);
