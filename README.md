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

## The motivation

I like cool outfits and electronics, and I've been itching for a good embedded project for a long time.

Specifically, I think this would be really cool to show off at the upcoming EMFcamp 2026.

Inspirations:

* A technologically similar project I did a few years ago, involving a WS2812 LED matrix (driven
  by a Teensy LC) mounted on a helmet visor.
* https://breq.dev/projects/outshine
* https://www.instagram.com/artpandora/

## The development story

* [Getting the project off the ground](doc/story/getting-started.md)
* [The toolchain, or: An Exercise in Masochism](doc/story/toolchain.md)
