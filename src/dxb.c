// Long jump to the label, avoiding any weird code generation.
// If we don't, we'll execute random code and go off past
// what we want to.
__asm__("jmp $0x0000, $_dxb_main\n");


void _dxb_main(void){
  for(;;);
}