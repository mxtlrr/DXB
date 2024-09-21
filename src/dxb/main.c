#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "libc/stdio.h"

extern int check_386(void);

enum CPUs {
	I286 = 0,
	I386 = 1
};
char* cpus[] = {
	"80286",
	"80386"
};

void kmain(void){
	printf("%gWELCOME%g TO DXB!\n", VGA_COLOR_RED, VGA_COLOR_WHITE);

	/* Detect between 286 and 386+. The BIOS ROM is at different locations
	 * depending on where it is. */
	int v = check_386();
	printf("Detected %g%s%g...\n", VGA_COLOR_GREEN, cpus[v], VGA_COLOR_GREEN);

	// Halt, we're done...
	// Eventually I'll add some GDT/IDT...
	for(;;);
}
