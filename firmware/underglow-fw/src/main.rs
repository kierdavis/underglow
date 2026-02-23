#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _; // you can put a breakpoint on `rust_begin_unwind` to catch panics

#[entry]
fn main() -> ! {
  loop {
    // your code goes here
  }
}
