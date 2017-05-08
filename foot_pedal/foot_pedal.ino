#include <cmdline_defs.h>
#include <ProTrinketKeyboard.h>
#include <ProTrinketKeyboardC.h>
#include <usbconfig.h>

      /*
Trinket USB Foot Switch

Based on TrinketKeyboard example using the Trinket Keyboard Library
For Trinket (ATtiny85 based board) by Adafruit Industries

Version 1.0  2015-01-19 Initial version     Mike Barela

Support Adafruit tutorials by buying parts from Adafruit.com
*/


const int PIN_SWITCH = 0;    // Trinket pin to connect to switch 
const int LED        = 13;
const int PRESS_THRESHOLD = 500;
int   pressed        = 0;
int   ledOn          = 0;
long lastPress       = 0;
long  sincePressed   = 0;

void setup()
{
  // Set button pin as input with an internal pullup resistor
  // The button is active-low, they read LOW when they are not pressed
  pinMode(PIN_SWITCH, INPUT_PULLUP);

  TrinketKeyboard.begin();  // initialize keyboard library
}

void loop()
{
  TrinketKeyboard.poll();
  // the poll function must be called at least once every 10 ms
  // or the computer may think that the device
  // has stopped working, and give driver errors

  if((millis() - lastPress) > PRESS_THRESHOLD && ledOn) {
    ledOn = 0;
    digitalWrite(LED, LOW);
  }
 

  if (digitalRead(PIN_SWITCH) == LOW && ((millis() - lastPress) > PRESS_THRESHOLD))  // If the foot switch grounds the pin
  {
    if(pressed == 0) {
      TrinketKeyboard.pressKey(0, KEYCODE_F8);
      TrinketKeyboard.pressKey(0, 0);  // release key
      pressed = 1;
      lastPress = millis();
      ledOn = 1;
      digitalWrite(LED, HIGH);
    }
  } else {
    pressed = 0;
  }
}
    
