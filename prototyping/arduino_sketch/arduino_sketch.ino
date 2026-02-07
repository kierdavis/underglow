int phase = 0;

// Ranges from 0 to 31 (inclusive).
int step = 0;

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
  int fallingLED, risingLED, offLED;
  if (phase == 0) {
    fallingLED = LEDR;
    risingLED = LEDG;
    offLED = LEDB;
  }
  else if (phase == 1) {
    fallingLED = LEDG;
    risingLED = LEDB;
    offLED = LEDR;
  }
  else {
    fallingLED = LEDB;
    risingLED = LEDR;
    offLED = LEDG;
  }
  analogWrite(fallingLED, 255 - (31-step)*4);
  analogWrite(risingLED, 255 - step*4);
  analogWrite(offLED, 255);
  step = (step + 1) % 32;
  if (step == 0) {
    phase = (phase + 1) % 3;
  }
  delay(1000 / 32);
}
