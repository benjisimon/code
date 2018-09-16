let Modes = { Recording: 0, Playing: 1 };
let Symbols = { None: -1 };

let current = {
  symbol: Symbols.None,
  mode: Modes.Playing,
  started: input.runningTime(),
  step: 0,
  sequence: [
    { t: 0, s: IconNames.No },
    { t: 250, s: Symbols.None },
    { t: 500, s: IconNames.Target },
    { t: 750, s: Symbols.None },
    { t: 1000, s: IconNames.Square },
    { t: 1250, s: Symbols.None }
  ]
};

basic.forever(() => {
  if(current.mode == Modes.Playing && input.buttonIsPressed(Button.A)  && isTwistedLeft()) {
    startRecording();
  } else if(current.mode == Modes.Recording && input.buttonIsPressed(Button.B) && isTwistedRight()) {
    startPlaying();
  } else {
    if(current.mode == Modes.Recording) {
      if(input.buttonIsPressed(Button.A) && input.buttonIsPressed(Button.B)) {
        record(IconNames.Target);
      } else if(input.buttonIsPressed(Button.A)) {
        record(IconNames.No);
      } else if(input.buttonIsPressed(Button.B)) {
        record(IconNames.Square);
      } else {
        record(Symbols.None);
      }
    } else {
      let offset = input.runningTime() - current.started;
      if(offset > current.sequence[current.step].t) {
        render(current.sequence[current.step].s);
        if(current.step+1 < current.sequence.length) {
          current.step++;
        } else {
          startPlaying();
        }
      }
    }
  }
});

function render(symbol: number): void {
  if(current.symbol !== symbol) {
    current.symbol = symbol;
    if(symbol === Symbols.None) {
      basic.clearScreen();
    } else {
      basic.showIcon(symbol);
    }
  }
}

function record(symbol: number):void {
  if(current.symbol !== symbol) {
    current.sequence.push({ t: input.runningTime() - current.started,
                            s: symbol });
    render(symbol);
  }
}

function isTwistedLeft():boolean {
  return input.rotation(Rotation.Roll) < 45 ;
}

function isTwistedRight():boolean {
  return input.rotation(Rotation.Roll) > 45 ;
}

function startRecording():void {
  current.mode     = Modes.Recording;
  current.sequence = [];
  current.started  = input.runningTime();
}

function startPlaying():void {
  current.mode    = Modes.Playing;
  current.step    = 0;
  current.started = input.runningTime();
}
