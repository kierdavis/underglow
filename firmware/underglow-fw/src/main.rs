#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _; // you can put a breakpoint on `rust_begin_unwind` to catch panics

#[derive(Clone, Copy)]
enum Colour {
  Red,
  Green,
  Blue,
}

#[derive(Clone, Copy)]
enum GPIOPin {
  Red,
  Green,
  Blue,
}

#[entry]
fn main() -> ! {
  loop {
    Colour::Red.show();
    delay_one_second();
    Colour::Green.show();
    delay_one_second();
    Colour::Blue.show();
    delay_one_second();
  }
}

impl Colour {
  fn show(self) {
    match self {
      Self::Red => {
        GPIOPin::Red.set_output_state(true);
        GPIOPin::Green.set_output_state(false);
        GPIOPin::Blue.set_output_state(false);
      }
      Self::Green => {
        GPIOPin::Red.set_output_state(false);
        GPIOPin::Green.set_output_state(true);
        GPIOPin::Blue.set_output_state(false);
      }
      Self::Blue => {
        GPIOPin::Red.set_output_state(false);
        GPIOPin::Green.set_output_state(false);
        GPIOPin::Blue.set_output_state(true);
      }
    }
  }
}

impl GPIOPin {
  fn set_output_state(self, state: bool) {
    todo!()
  }
}

fn delay_one_second() {
  todo!()
}
