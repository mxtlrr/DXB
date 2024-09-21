#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "libc/stdio.h"

void kmain(void){
	printf("%gWELCOME%g TO DXB!\n", VGA_COLOR_RED, VGA_COLOR_WHITE);

	for(;;);
}
