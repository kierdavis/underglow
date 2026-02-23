#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _; // you can put a breakpoint on `rust_begin_unwind` to catch panics
use volatile_register::WO;

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
    const GPIO0_OUTSET: *const WO<u32> = 0x50000508 as *const _;
    const GPIO0_OUTCLR: *const WO<u32> = 0x5000050C as *const _;
    todo!()
  }

  fn pin_index(self) -> usize {
    match self {
      Self::Red => 24,
      Self::Green => 16,
      Self::Blue => 6,
    }
  }
}

fn delay_one_second() {
  todo!()
}
