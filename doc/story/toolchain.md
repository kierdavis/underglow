# The toolchain, or: An Exercise in Masochism

The microcontroller board I've chosen for this project is the
[Arduino Nano 33 BLE Sense Rev2][nano33ble2].

If I were a normal, sane person who had a healthy relationship with project
timelines, I'd use the Arduino SDK, with its built-in support for the
microcontroller and libraries for all the sensors I want to use. This'd let me
start writing useful code right away!

Unfortunately (for you), I like taking matters into my own hands.
There's a few reasons why I stepped right over using the Arduino SDK:

- I wanted to get some practice at using Rust for a real embedded software project.
- I expect my software will have to do some fairly heavy computation (for the 3D
  spatial stuff) on a fairly modest microcontroller - for which I'll want to have
  a lot of control over the compiler's code generation and the hardware drivers.
- I just enjoy playing with low-level stuff like this!

Fortunately there's already great support for writing embedded software in Rust!
Especially so for ARM Cortex-M microcontrollers like the one on the BLE Sense Rev2.
The [Embedded Rust Book][book] is a fantastic place to learn about the concepts.

## Step 1: Installing Rust with embedded support

The Arduino Nano 33 BLE Sense Rev2 board features a Nordic nRF52840 microcontroller,
which is built around an ARM Cortex-M4F processor core. We'll need to tell Rust
to compile code for this architecture instead of for the architecture the compiler
is running on (`x86_64`, most likely). Rust is able to do this out of the box,
but it doesn't ship with the necessary pre-compiled `core` crate. We'll need to
add this to our Rust installation.

If you're using Nix to manage development tools like me, this is easy to do with
[fenix][]. See [this commit][rust-nix-commit] where I define a customised Rust
toolchain (i.e. a Nix package with `cargo` and `rustc` executables) and add it
to my dev shell.

Otherwise, it's best to install Rust using [rustup][]; then installing the
pre-compiled `core` crate is a one-liner:

```shell
rustup target add thumbv7em-none-eabihf
```

`thumbv7em-none-eabihf` is Rust's name for the embedded ARM Cortex-M4F
architecture, as is used on the Arduino Nano 33 BLE Sense Rev2.

[book]: https://doc.rust-lang.org/beta/embedded-book/
[fenix]: https://github.com/nix-community/fenix
[nano33ble2]: https://docs.arduino.cc/hardware/nano-33-ble-sense-rev2/
[rustup]: https://rustup.rs/
[rust-nix-commit]: https://github.com/kierdavis/underglow/commit/0303d142465da51cee1706e7fbdd3f690dccab28
