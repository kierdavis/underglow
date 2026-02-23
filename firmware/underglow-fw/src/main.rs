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
    todo!()
  }
}

fn delay_one_second() {
  todo!()
}
