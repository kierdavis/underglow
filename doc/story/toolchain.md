# The toolchain, or: An Exercise in Masochism

The microcontroller board I've chosen for this project is the
[Arduino Nano 33 BLE Sense Rev2][nano33ble2].

If I were a normal, sane person who had a healthy relationship with project
timelines, I'd use the Arduino SDK, with its built-in support for the
microcontroller and libraries for all the sensors I want to use. This'd let me
start writing useful code right away!

Unfortunately (for you), I like taking matters into my own hands.
There's a few reasons why I stepped right over using the Arduino SDK:

* I wanted to get some practice at using Rust for a real embedded software project.
* I expect my software will have to do some fairly heavy computation (for the 3D
  spatial stuff) on a fairly modest microcontroller - for which I'll want to have
  a lot of control over the compiler's code generation and the hardware drivers.
* I just enjoy playing with low-level stuff like this!

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

## Step 2: Creating a Rust crate for our project

I'll be leaning heavily on the industry-standard [`cortex-m`][cortex-m] crate
for this project. Not only does it provide an API for accessing standard Cortex-M
peripherals like SysTick, it also takes care of mapping our program onto the
specific processor's memory layout and initialising RAM at startup.

However, there are some elements of the setup that `cortex-m` can't encapsulate;
we'll need several additional config files beyond what exists in a typical Rust
crate. Fortunately there are project templates available!

The template that the `cortex-m` maintainers currently recommend for use is
[`knurling-rs/app-template`][knurling-template], but this contains a lot of
extra features that I won't need any time soon, like serial logging. Instead
I'll use [`cortex-m-quickstart`][cortex-m-quickstart] which is no longer
maintained but should still work fine, and is much closer to what I'm looking for.

I started by [copying the contents of `cortex-m-quickstart` into a new folder
in this repository][quickstart-commit], excluding things that obviously aren't
needed like the original README or the `examples` folder. Then I proceeded to:

* [update the crate name/metadata to be relevant to this project][crate-metadata-commit]
* [tell the Rust compiler which CPU to compile for][target-platform-commit]
* [tell the linker what the memory layout of our specific CPU is][memory-layout-commit]
* [update to the latest edition of Rust][rust-edition-commit], since the template
  is pretty outdated in this regard
* [remove the dependency on `cortex-m-semihosting`][semihosting-commit]
  (this provides facilities for logging over serial, which I don't plan to do
  any time soon)
* [remove commented-out code that isn't relevant to this project][cleanup-commit]
* [switch to using a Cargo workspace][workspace-commit], since I expect to break
  up this project into multiple crates

And then we're all set to compile the project for the first time!

```console
[.../underglow/firmware]$ cargo build --release -p underglow-fw
   Compiling proc-macro2 v1.0.106
   Compiling semver-parser v0.7.0
   Compiling quote v1.0.44
   Compiling unicode-ident v1.0.24
   Compiling nb v1.1.0
   Compiling cortex-m v0.7.7
   Compiling semver v0.9.0
   Compiling cortex-m-rt v0.7.5
   Compiling nb v0.1.3
   Compiling vcell v0.1.3
   Compiling rustc_version v0.2.3
   Compiling void v1.0.2
   Compiling volatile-register v0.2.2
   Compiling embedded-hal v0.2.7
   Compiling bitfield v0.13.2
   Compiling bare-metal v0.2.5
   Compiling underglow-fw v0.1.0 (.../underglow/firmware/underglow-fw)
   Compiling critical-section v1.2.0
   Compiling panic-halt v1.0.0
   Compiling syn v2.0.117
   Compiling cortex-m-rt-macros v0.7.5
    Finished `release` profile [optimized + debuginfo] target(s) in 4.40s
```

We can see that cargo spat out an executable in the
`target/thumbv7em-none-eabihf/release` directory, and we can confirm that this
executable uses the ARM instruction set rather than x86_64:

```console
[kier@coloris:~/underglow/firmware]$ file target/thumbv7em-none-eabihf/release/underglow-fw
target/thumbv7em-none-eabihf/release/underglow-fw: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, with debug_info, not stripped
                                                       ^^^^^^                 ^^^
```

[book]: https://doc.rust-lang.org/beta/embedded-book/
[cleanup-commit]: https://github.com/kierdavis/underglow/commit/49c7eb11c1705ca4df18305eb1155c52be4e96d8
[cortex-m]: https://crates.io/crates/cortex-m
[cortex-m-quickstart]: https://github.com/rust-embedded/cortex-m-quickstart/tree/ac02415275d0190a1a7aa730ec2b0bdf7c3ef88f
[crate-metadata-commit]: https://github.com/kierdavis/underglow/commit/5f029c0e43cbce34e5f0259bb4e3c75f97a7f4c5
[fenix]: https://github.com/nix-community/fenix
[knurling-template]: https://github.com/knurling-rs/app-template
[memory-layout-commit]: https://github.com/kierdavis/underglow/commit/64135aa8e4deedc293c1cd67360de83a2da19175
[nano33ble2]: https://docs.arduino.cc/hardware/nano-33-ble-sense-rev2/
[quickstart-commit]: https://github.com/kierdavis/underglow/commit/9170d92bd875456be7652712e49946c1f01ec32c
[rustup]: https://rustup.rs/
[rust-edition-commit]: https://github.com/kierdavis/underglow/commit/02e7828f417eaeee5a3c6f25da7d9d38e9d10886
[rust-nix-commit]: https://github.com/kierdavis/underglow/commit/0303d142465da51cee1706e7fbdd3f690dccab28
[semihosting-commit]: https://github.com/kierdavis/underglow/commit/08be183c09fe008c20cc0571f3faedf40e5aee55
[target-platform-commit]: https://github.com/kierdavis/underglow/commit/8d0356ea12e54f0041bd9361d960050258da2386
[workspace-commit]: https://github.com/kierdavis/underglow/commit/18a1819da1c746650a45d34f274508fbe8081ca6
