# underglow

A wearable tech concept.

## The goal

Core:

* An outfit lined with many addressable LEDs (shoulders, waist, boots, wrists, collar).
* LEDs are mapped in 3D space, allowing for visually cohesive 3D animations.
* Simple Android app to select animations via Bluetooth (is there an off-the-shelf app?)
* Maybe a physical button or two as an alternative means of control, if Bluetooth stops working.

Cool add-on hardware:

* Microphone, to allow animation to be synced to any music that's playing around me.
* Motion sensor (IMU?) on each boot, to allow animation to be synced to my footsteps.
* IMU, to allow animation to be synced to the direction I'm facing or the speed I'm moving at.

Animation ideas:

* Typical "xmas lights" effects: solid colour, gentle "breathing", rapid "disco" patterns.
* Waves of colour, originating from the heart and spreading over the body, in time with the beat of the music.
* Waves of colour originating from my feet as I walk.
* Inertially static colour field.

## The story

### Why?

I like cool outfits and electronics, and I've been itching for a good embedded project for a long time.

Specifically, I think this would be really cool to show off at the upcoming EMFcamp 2026.

Inspirations:

* A technologically similar project I did a few years ago, involving a WS2812 LED matrix (driven
  by a Teensy LC) mounted on a helmet visor.
* https://breq.dev/projects/outshine
* https://www.instagram.com/artpandora/

### So, where do I start?

This is what I reckon I'll need to do (not necessarily in this order):

* Design and make/buy the outfit (the fabric-ness).
* Attach a load of WS2812 LED strips to the outfit.
* Figure out a discreet wiring solution - such that all the outfit pieces are separate and
  can be plugged together once I'm wearing them.
* Get hold a microcontroller board that meets my requirements.
* Write firmware:
  * "Hello world" (i.e. get the toolchain working)
  * WS2812 driver
  * Animation controller
  * Bluetooth driver
  * State machine for moving from one animation/mode to another (as directed by Bluetooth or buttons)
  * Drivers and algorithms for add-on hardware
* Assemble power supply (battery, DC-to-DC converter, distribution).
* Design and 3D print an enclosure for the microcontroller and power supply, and a way to mount it on the outfit.
* ???

### Which microcontroller / board?

I've previously done efficient driving of WS2812 LEDs on a Teensy LC before, but these boards
seem to be out of production now, and they don't have builtin Bluetooth.

Requirements for a new board:

* Suitable form factor for wearable elctronics (small, ideally headerless).
* Ideally, builtin Bluetooth, because I don't want too many discrete boards flying around.
* SPI capable of transmitting at a baud rate of 2,400,000; that's 300,000 bytes/sec
  continuous transmission, or 266,666 bytes/sec with a 1 bit-duration gap between bytes
  (as is the case on the Teensy LC).
* DMA capable of transferring from RAM to the aforementioned SPI peripheral.
* Some EEPROM to save the current animation & colour selections.
* Either a bultin IMU, or an I2C interface to talk to one.
* Powerful enough to do real-time pixel calculations - this will definitely come into play for the IMU-based animations.
* Ideally ARM-based, because I'd like to get some experience of embedded Rust;
  but it's not the end of the world if I have to fall back to C++.
* Microcontroller is ideally available in an easily-solderable package. I can
  forsee the electronics getting complex enough that I might need a custom PCB, and
  I don't want to have to port my code to another architecture or deal with trying
  to solder QFNs when that time comes.

Most boards don't mention whether or not they have DMA in their product pages, so I might have
to do a lot of digging through datasheets... [This list][microcontroller-list-upstream] looks like a
good starting point though. I'll [copy it into this repo][microcontroller-list] and annotate each
board with whether it's viable or not.


[microcontroller-list-upstream]: https://github.com/Slayingripper/MicroControllers
[microcontroller-list]: design-docs/microcontroller-comparison.md
