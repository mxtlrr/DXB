#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "bios.h"
#include "arch/idt.h"
#include "disk/ata.h"
#include "libc/stdio.h"

extern int check_386(void);
extern void load_gdt(void);

char* cpus[] = {
	"80286",
	"80386"
};

void kmain(void){
	printf("%gWELCOME%g TO DXB!\n", VGA_COLOR_RED, VGA_COLOR_WHITE);

	/* Detect between 286 and 386+. The BIOS ROM is at different locations
	 * depending on where it is. */
	int v = check_386();
	printf("Detected %g%s%g as your CPU.\n\n", VGA_COLOR_GREEN, cpus[v],
					VGA_COLOR_WHITE);

	load_gdt();
	printf("[ %gOK%g ] GDT is enabled!\n", VGA_COLOR_LIGHT_GREEN, VGA_COLOR_WHITE);

	idt_init();
	printf("[ %gOK%g ] IDT is enabled!\n", VGA_COLOR_LIGHT_GREEN, VGA_COLOR_WHITE);

	printf("[ %gTEST%g ] Testing ATA ident driver\n", VGA_COLOR_CYAN, VGA_COLOR_WHITE);
	ident_drive(MASTER_DRIVE);

	for(;;) asm("hlt");
}
