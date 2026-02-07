# The toolchain, or: An Exercise in Masochism

The microcontroller board I've chosen for this project is the
[Arduino Nano 33 BLE Sense Rev2][nano33ble2].

If I were a normal, sane person who had a healthy relationship with project timelines,
I'd use the Arduino SDK, with its built-in support for the microcontroller and libraries
for all the sensors I want to use. This'd let me start writing useful code right away!

Unfortunately (for you), I like taking matters into my own hands.
There's a few reasons why I stepped right over using the Arduino SDK:

* I expect my software will have to do some fairly heavy computation (for the 3D
  spatial stuff) on a fairly modest microcontroller - for which I'll want to have
  a lot of control over the compiler's code generation and the hardware drivers.
* I wanted to get some practice at using Rust for a real embedded software project.
* I just enjoy playing with low-level stuff like this!

But, that's not to say I'll be working _entirely_ from scratch! I'll start with
an Arduino IDE sketch, and transition it step by step into what I want.

## Demo program / Arduino sketch

To fiddle with the toolchain, I'll need a simple demo program to operate on.
I wrote a [quick 'n' dirty sketch][colourwheelcode] to cycle the onboard LED through the RGB spectrum.

![Video depicting the program running on the Arduino][colourwheelgif]


[colourwheelcode]: ../../prototyping/arduino_sketch/arduino_sketch.ino
[colourwheelgif]: ../assets/colour_wheel_demo.gif
[nano33ble2]: https://docs.arduino.cc/hardware/nano-33-ble-sense-rev2/
