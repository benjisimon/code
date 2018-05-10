OLED.init(64, 128);
basic.showIcon(IconNames.Square);

let DURATIONS     = [ 60, 60 * 60, 60 * 60 * 24 ];
let durationIndex = 1;
let timerNow      = 0;
let timerStep     = 0;
let timerRunning  = false;

function eachLed(fn : ( x : number, y : number, i : number) => void) : void {
  for(let i = 0; i < 25; i++) {
    let x = i % 5;
    let y = i / 5;
    fn(x, y, i);
  }
}

function timerReset() {
  timerRunning = true;
  timerNow     = 0;
  timerStep    = DURATIONS[durationIndex] / 25;

  basic.clearScreen();
};

function timerTick() {
  if(!timerRunning) {
    return;
  }

  timerNow++;    
  eachLed((x, y, i) => {
    let special = (x == 2 && y == 2);
    if(!special && (i * timerStep) < timerNow) {
      led.plot(x, y);
    }
  });
  led.toggle(2,2);
}

function timerSelect(offset : number) {
  timerRunning = false;
  durationIndex = (DURATIONS.length + (durationIndex + offset)) % DURATIONS.length;
  basic.clearScreen();
  basic.showNumber(durationIndex);
  basic.pause(1500);
  timerReset();
}

input.onButtonPressed(Button.A, () => { timerSelect(-1); });
input.onButtonPressed(Button.B, () => { timerSelect(1); });


basic.forever(() => {
  if(input.pinIsPressed(TouchPin.P0) && !timerRunning) {
    timerReset();
  }

  timerTick();
  basic.pause(1000);
})


input.onPinReleased(TouchPin.P0, () => {
  timerRunning = false;
  basic.showIcon(IconNames.Target)
}) 
