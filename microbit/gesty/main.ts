let debug     = true;
let nextNote  = input.runningTime();


if(debug) {
  OLED.init(64, 128);
}

basic.forever(() => {
  let now = input.runningTime();
  let roll = 90 + input.rotation(Rotation.Roll);
  let pitch = 90 + input.rotation(Rotation.Pitch)
  let right = roll / 36;
  let down = pitch / 36;
  let freq = 131 + (roll * 5);
  let rest = 20;
  let duration = pitch * 3;
  let fudge    = pins.analogReadPin(AnalogPin.P1);

  basic.clearScreen();
  led.plot(right, down);

  if(now > nextNote) {
    nextNote = input.runningTime() + duration + rest;
    
    music.playTone(freq + (input.buttonIsPressed(Button.A) ? fudge  : 0) , 
                   duration + (input.buttonIsPressed(Button.B) ? fudge  : 0));
  }

  if(debug) {
    OLED.showString(roll + "/" + freq + "::" + pitch + "/" + duration + "::" + fudge);
  }
});


music.playTone(400, 1000);
