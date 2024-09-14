// Long jump to the label, avoiding any weird code generation.
// If we don't, we'll execute random code and go off past
// what we want to.
__asm__("jmp $0x0000, $_dxb_main\n");

typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;

void __int10h(uint16_t ax){
  __asm__("mov %0, %%ax\nint $0x10" ::"r"(ax) :"%ax");
}


#define putc(x) __int10h(0x0e00 | x);
void puts(char* s){
  for(int z = 0; s[z] != '\0'; z++) 
    putc(s[z]);
}

// Write a byte to output
void putb(uint8_t byte){
  uint8_t hi = byte >> 4;
  uint8_t lo = byte & 0x0f;

  if(hi > 9){ putc(((hi-10) + 0x41)); }
  else {      putc((hi + 0x30));      }

  if(lo > 9){ putc(((lo-10) + 0x41)); }
  else {      putc((lo + 0x30));      }
  
}


// Ok, let's do some fun stuff!
// Sort of a port of a DOS program. You can see it
// here: https://web.archive.org/web/20171130135644/http://www.mess.org/_media/dumping/dumpat.zip
#define BIOS_START_386 0xfff0000
#define BIOS_SIZE      0xFFFF    // 65kb
// Rarely mapped to different locations, but you never know!:)

void _dxb_main(void){
  putb(0xfa);
  for(;;);
}