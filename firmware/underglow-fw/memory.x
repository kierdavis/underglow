MEMORY
{
  /* Memory layout sourced from the linker script used by the Arduino toolchain:
   *   https://github.com/arduino/ArduinoCore-mbed/blob/aea05a0/variants/ARDUINO_NANO33BLE/linker_script.ld
   * and checked against the nRF52840 datasheet:
   *   https://content.arduino.cc/assets/Nano_BLE_MCU-nRF52840_PS_v1.1.pdf
   *
   * The first 0x10000 bytes of flash are reserved for the Arduino bootloader.
   *
   * TODO: The Arduino/MbedOS toolchain reserves the first 0x200 bytes of RAM as
   * "RAM_NVIC" and "RAM_CRASH_DATA" - is it necessary to replicate that if we
   * aren't using this toolchain?
   */
  FLASH : ORIGIN = 0x10000, LENGTH = 0xf0000
  RAM : ORIGIN = ((0x20000000 + 0x100) + 0x100), LENGTH = (0x40000 - (0x100 + 0x100))
}

/* This is where the call stack will be allocated. */
/* The stack is of the full descending type. */
/* You may want to use this variable to locate the call stack and static
   variables in different memory regions. Below is shown the default value */
/* _stack_start = ORIGIN(RAM) + LENGTH(RAM); */

/* You can use this symbol to customize the location of the .text section */
/* If omitted the .text section will be placed right after the .vector_table
   section */
/* This is required only on microcontrollers that store some configuration right
   after the vector table */
/* _stext = ORIGIN(FLASH) + 0x400; */

/* Example of putting non-initialized variables into custom RAM locations. */
/* This assumes you have defined a region RAM2 above, and in the Rust
   sources added the attribute `#[link_section = ".ram2bss"]` to the data
   you want to place there. */
/* Note that the section will not be zero-initialized by the runtime! */
/* SECTIONS {
     .ram2bss (NOLOAD) : ALIGN(4) {
       *(.ram2bss);
       . = ALIGN(4);
     } > RAM2
   } INSERT AFTER .bss;
*/
