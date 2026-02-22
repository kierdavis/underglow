# Getting the project off the ground

## Where do I start??

This is all the stuff I figured I'll need to do:

* Design and make/buy the outfit (the fabric-ness).
* Attach a load of WS2812 LED strips to the outfit.
* Figure out a discreet wiring solution - such that all the outfit pieces are
  separate and can be plugged together once I'm wearing them.
* Get hold of a microcontroller board that meets my requirements.
* Write firmware:
  * "Hello world" (i.e. get the toolchain working)
  * WS2812 driver
  * Animation controller
  * Bluetooth driver
  * State machine for moving from one animation/mode to another (as directed by
    Bluetooth or buttons)
  * Drivers and algorithms for add-on hardware
* Assemble power supply (battery, DC-to-DC converter, distribution).
* Design and 3D print an enclosure for the microcontroller and power supply, and
  a way to mount it on the outfit.
* ???

## Which microcontroller / board?

This seemed like a good thing to deal with early - it's hard to write code
without knowing what hardware you're writing it for.

I'd previously done efficient driving of WS2812 LEDs on a Teensy LC before, but
this board seems to be out of production now, and it doesn't have builtin Bluetooth.

Requirements for a new board:

* Suitable form factor for wearable elctronics (small, ideally headerless).
* Ideally, builtin Bluetooth, because I don't want too many discrete boards
  flying around.
* SPI capable of transmitting at a baud rate of 2,400,000; that's 300,000 bytes/sec
  continuous transmission, or 266,666 bytes/sec with a 1 bit-duration gap between
  bytes (as is the case on the Teensy LC).
* DMA capable of transferring from RAM to the aforementioned SPI peripheral.
* Some EEPROM to save the current animation & colour selections.
* Either a bultin IMU, or an I2C interface to talk to one.
* Powerful enough to do real-time pixel calculations - this will definitely come
  into play for the IMU-based animations.
* Ideally ARM-based, because I'd like to get some experience of embedded Rust;
  but it's not the end of the world if I have to fall back to C++.
* Microcontroller is ideally available in an easily-solderable package. I can
  forsee the electronics getting complex enough that I might need a custom PCB,
  and I don't want to have to port my code to another architecture or deal with
  trying to solder QFNs when that time comes.

[This list][microcontroller-list-upstream] looked like a good starting point though.
I [copied it into this repo][microcontroller-list] and started annotating each board
with whether it's viable or not.

However I didn't get very far :) One of the first ones I looked at, the
[Arduino Nano 33 BLE][nano33ble], appeared to fit the bill exactly: it has a
fairly beefy ARM CPU, a builtin Bluetooth, IMU and microphone, and is physically
small and low-profile. The only downside was that it's discontinued, but its
latest successor (the long-winded [Arduino Nano 33 BLE Sense Rev2][nano33ble2])
has all the same features and more.

While there may be other, cheaper boards that also fulfil these requirements,
I didn't want to spend ages agonising over product choices at this stage of the
project. I went ahead and bought a Nano 33 BLE Sense Rev2 to start experimenting
with.

[microcontroller-list-upstream]: https://github.com/Slayingripper/MicroControllers
[microcontroller-list]: ../design/microcontroller-comparison.md
[nano33ble]: https://docs.arduino.cc/hardware/nano-33-ble/
[nano33ble2]: https://docs.arduino.cc/hardware/nano-33-ble-sense-rev2/
