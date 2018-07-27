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


// This is calibration data for the raw touch data to the screen coordinates
#define TS_MINX 3800
#define TS_MAXX 100
#define TS_MINY 100
#define TS_MAXY 3750

// Size of the color selection boxes and the paintbrush size
#define BOXSIZE 40
#define PENRADIUS 3
long started = millis() / 1000;

void setup(void) {
  Serial.begin(115200);

  delay(10);
  Serial.println("FeatherWing TFT");
  

  if (!ts.begin()) {
    Serial.println("Couldn't start touchscreen controller");
    while (1);
  }
  Serial.println("Touchscreen started");
}

void loop(void) {
  long remaining = (millis() / 1000) - started;
  int hours = remaining / (60 * 60);
  remaining = hours == 0 ? remaining : remaining % (hours * 60 * 60);
  int minutes = remaining / 60;
  remaining = minutes == 0 ? remaining : remaining % (60 * minutes);
  int seconds = remaining;

  int red = minutes/2;
  int green = 61 - minutes;
  int blue = 31;
  int fg = ((red) << 11) | ((green) << 6) | blue;
  int bg = ~fg;
  
  tft.begin();
  tft.setRotation(3);
  tft.fillScreen(fg);
  tft.setCursor(10,(tft.height() / 2) - 30);
  tft.setTextColor(bg);
  tft.setTextSize(7);

  tft.print(hours);
  tft.print(":");
  if(minutes < 10) {
    tft.print("0");
  }
  tft.print(minutes);
  tft.print(":");
  if(seconds < 10) {
    tft.print("0");
  }
  tft.print(seconds);

  delay(750);
}


