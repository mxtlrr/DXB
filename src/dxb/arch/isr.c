#include "arch/isr.h"

uint8_t get_op(uint32_t place){
  return (*(uint32_t*)place) & 0xff;
}

void exception_handler(registers_t* r){
  set_color(VGA_COLOR_RED);
  printf("Exception occurred at %x:%x. [%x %x %x] (v=%x)\n", r->cs, r->ip,
      get_op(r->ip-1), get_op(r->ip), get_op(r->ip+1), r->int_no);
  printf("Register dump:\n");
  printf("EAX: %x | EBX: %x | ECX: %x | EDX: %x\n", r->eax, r->ebx, r->ecx,
      r->edx);
  printf("ESI: %x | EDI: %x | EBP: %x | ESP: %x\n\n", r->esi, r->edi, r->ebp,
      r->esp);

  set_color(VGA_COLOR_CYAN);
  printf("Please open an issue on GitHub, you shouldn't be seeing this.\n");
  printf("<github.com/mxtlrr/DXB> || %gSystem halted.", VGA_COLOR_BROWN);

  for(;;) asm("cli//hlt");
}