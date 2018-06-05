let debug = false;

if(debug) {
  OLED.init(64, 128);
}

basic.forever(() => {
  let roll = 90 + input.rotation(Rotation.Roll);
  let pitch = 90 + input.rotation(Rotation.Pitch)
  let right = roll / 36;
  let down = pitch / 36;
  basic.clearScreen();
  led.plot(right, down);

  if(debug) {
    OLED.showString(roll + "::" + pitch + "//" + right + "x" + down);  
  }
});
