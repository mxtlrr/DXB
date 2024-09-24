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

// Set to whatever device we're writing to. If 0, then not writing.
// Should be ATA/PATA. Soon I'll write a SATA / ATAPI drive, but
// for now, just PATA.
int to_write = 0;

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

	printf("[ %gATA%g ] Identifying drives...\n", VGA_COLOR_CYAN, VGA_COLOR_WHITE);
	
	uint8_t master = ident_drive(MASTER_DRIVE);
	uint8_t slave  = ident_drive(SLAVE_DRIVE);

	// Kinda disgusting code, but oh well
	if(master == slave && slave == NO_DEV){
		printf("[ %gATA%g ] No devices suitable!\n", VGA_COLOR_CYAN, VGA_COLOR_WHITE);
		to_write = 0;
	}
	if(master == PATA_DEV && master != slave){
		printf("[ %gATA%g ] Using master drive!\n", VGA_COLOR_CYAN, VGA_COLOR_WHITE);
		to_write = MASTER_DRIVE;
	}
	if(slave == PATA_DEV && master != slave){
		printf("[ %gATA%g ] Using slave drive!\n", VGA_COLOR_CYAN, VGA_COLOR_WHITE);
		to_write = SLAVE_DRIVE;
	}
	

	for(;;) asm("hlt");
}
