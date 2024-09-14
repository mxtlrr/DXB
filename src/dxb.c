// Long jump to the label, avoiding any weird code generation.
// If we don't, we'll execute random code and go off past
// what we want to.
__asm__("jmp $0x0000, $_dxb_main\n");

void __int10h(unsigned short ax){
  __asm__("mov %0, %%ax\nint $0x10" ::"r"(ax) :"%ax");
}


#define putc(x) __int10h(0x0e00 | x);
void puts(char* s){
  for(int z = 0; s[z] != '\0'; z++) 
    putc(s[z]);
}

// Write a byte to output
void putb(unsigned char byte){
  unsigned char hi = byte >> 4;
  unsigned char lo = byte & 0x0f;

  if(hi > 9){ putc(((hi-10) + 0x41)); }
  else {      putc((hi + 0x30));      }

  if(lo > 9){ putc(((lo-10) + 0x41)); }
  else {      putc((lo + 0x30));      }
  
}

void _dxb_main(void){
  putb(0xfa);
  for(;;);
}