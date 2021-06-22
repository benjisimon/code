/*
 * A micro:bit implementation of a digital tamper seal
 */

let clock = 0;
let tick  = control.millis();
let moved = 0;
let lastAx = input.acceleration(Dimension.X);
let lastAy = input.acceleration(Dimension.Y);
let lastAz = input.acceleration(Dimension.Z);
let resetAt = control.millis();

function redraw() {
    basic.clearScreen()
    led.plot(0, clock);
    if(moved == 1) {
        led.plot(4, 0);
    }
}

function reset() {
    resetAt = control.millis();
    clock = 0;
    moved = 0;
}

function checkMoved() {
    let now = control.millis();
    if((now - resetAt) > 3000) {
        let dx = Math.abs(lastAx - input.acceleration(Dimension.X)) 
        let dy = Math.abs(lastAy - input.acceleration(Dimension.Y));
        let dz = Math.abs(lastAz - input.acceleration(Dimension.Z));
        let tolerance = 20;

        if(dx > tolerance  || dy > tolerance || dz > tolerance) {
            moved = 1;
            serial.writeLine("M:" + dx + "/" + dy + "/" + dz);
            console.log("M:" + dx + "/" + dy + "/" + dz);
        }
    } else {
        lastAx = input.acceleration(Dimension.X);
        lastAy = input.acceleration(Dimension.Y);
        lastAz = input.acceleration(Dimension.Z);
    }
}


basic.forever(function () {
    checkMoved();
    if(input.buttonIsPressed(Button.A)) {
        reset();
    }
    let now = control.millis();
    let diff = (now - tick) / 1000;
    tick = now;
    clock = (clock + diff) % 5;
    redraw();
});

