#include "libc/stdio.h"

volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;
#define TAB_SIZE 4
int x_pos = 0; int y_pos = 0;
uint8_t color = VGA_COLOR_WHITE;

void putc(unsigned char c){
  uint16_t attrib = (0 << 4) | (color & 0x0F);
  volatile uint16_t * where;
  where = (volatile uint16_t *)0xB8000 + (y_pos * 80 + x_pos);
  *where = c | (attrib << 8);
	if(++x_pos >= 80){
		x_pos = 0;
		y_pos++;
	
	}

	if(y_pos >= 25) {
		x_pos = 0;
		scroll();
	}
}

void set_color(uint8_t col){
	color = col;
}

void puts(char* str){
	while(*str){
		switch(*str){
			case '\n':
				x_pos = 0;
				y_pos++;
				*str++;
				scroll();
				break;
			case '\t':
				for(int i = 0; i <= TAB_SIZE; i++) putc(' ');
				*str++;
				break;
			case '\v':
				for(int i = 0; i <= TAB_SIZE; i++) putc('\n');
				*str++;
				break;
			
			default:
				putc(*str);
				*str++;	
		}
	}
}

void scroll(){
	uint8_t attributeByte = (0 << 4) | (15 & 0x0F);
	uint16_t blank = 0x20 | (attributeByte << 8);

	if(y_pos >= 25){
		int i;
		for (i = 0*80; i < 24*80; i++) vga_buffer[i] = vga_buffer[i+80];

		for (i = 24*80; i < 25*80; i++) vga_buffer[i] = blank;
		y_pos = 24;
	}
}

void printf(char* fmt, ...) {
	va_list ap;
	va_start(ap, fmt);

	char* ptr;

	for (ptr = fmt; *ptr != '\0'; ++ptr) {
		if (*ptr == '%') {
			++ptr;
			switch (*ptr) {
				case 's':	// string
					puts(va_arg(ap, char*));
					break;
				case 'd': // integer
					puts(itos(va_arg(ap, int), 10));
					break;
				case 'x': // hexadecimal
					puts(itos(va_arg(ap, uint32_t), 16));
					break;
				case 'c': // char
					putc(va_arg(ap, int));
					break;

				case 'g': // color
					set_color(va_arg(ap, int));
					break;
			}
		} else {
			char t[2] = { *ptr, 0 };
			puts(t);
		}
	}
}