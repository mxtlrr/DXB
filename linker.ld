ENTRY(_dxb_main);

SECTIONS
{
  . = 0x7e00;
  .text : AT(0x7e00)
  {
    *(.text);
  }
}