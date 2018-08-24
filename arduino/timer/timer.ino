/*
 * See:
 *  https://raw.githubusercontent.com/adafruit/Adafruit_ILI9341/master/examples/touchpaint_featherwing/touchpaint_featherwing.ino
 * https://learn.adafruit.com/adafruit-2-4-tft-touch-screen-featherwing/resistive-touch-screen
 */
 

#include <Adafruit_STMPE610.h>
#include <SPI.h>
#include <Wire.h>      // this is needed even tho we aren't using it

#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ILI9341.h> // Hardware-specific library
#include <Adafruit_STMPE610.h>

#define STMPE_CS 32
#define TFT_CS   15
#define TFT_DC   33
#define SD_CS    14

Adafruit_ILI9341 tft = Adafruit_ILI9341(TFT_CS, TFT_DC);
Adafruit_STMPE610 ts = Adafruit_STMPE610(STMPE_CS);


long started = millis() / 1000;

void setup(void) {
  Serial.begin(115200);

  delay(10);
  Serial.println("Timer Time!");
  

  if (!ts.begin()) {
    Serial.println("Couldn't start touchscreen controller");
    while (1);
  }
}

void loop(void) {
  long remaining = (millis() / 1000) - started;
  int hours = remaining / (60 * 60);
  remaining = hours == 0 ? remaining : remaining % (hours * 60 * 60);
  int minutes = remaining / 60;
  remaining = minutes == 0 ? remaining : remaining % (60 * minutes);
  int seconds = remaining;

  int fg = textFg(hours, minutes, seconds);
  int bg = textBg(hours, minutes, seconds);
  int y   = (tft.height() / 3) - 60;
  
  tft.begin();
  tft.setRotation(2);
  tft.fillScreen(fg);
  tft.setTextColor(bg);
  tft.setTextSize(7);

  showTime(tft, hours + 1, "h", y);
  showTime(tft, minutes + 1, "m", y + 90);
  showTime(tft, seconds, "s", y + 180);
  

  delay(750);
}

void showTime(Adafruit_ILI9341 tft, int value, String unit, int y) {
  tft.setCursor(40, y);
  if(value > 0) {
    if(value < 10) {
      tft.print("0");
    }
    tft.print(value);
    tft.print(unit);
    tft.println();
  }
}
int textFg(int hours, int minutes, int seconds) {
  int red = minutes/2;
  int green = 61 - minutes;
  int blue = 31;
  return ((red) << 11) | ((green) << 6) | blue;
}

int textBg(int hours, int minutes, int seconds) {
  return ~ textFg(hours, minutes, seconds);
}


