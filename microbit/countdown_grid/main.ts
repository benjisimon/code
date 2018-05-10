OLED.init(64, 128);
basic.showIcon(IconNames.Square);

let DURATION     = 60 * 60;
let timerNow     = 0;
let timerStep    = 0;
let timerRunning = false;

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
  timerStep    = DURATION / 25;

  eachLed((x, y, i) => {
    led.unplot(x, y);
  });
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

input.onButtonPressed(Button.B, () => {
  if(input.buttonIsPressed(Button.A)) {
    timerReset();
  }
});

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
