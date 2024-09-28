#include "arch/idt.h"

__attribute__((aligned(0x10)))
static idt_entry_t idt[256];
static idtr_t idtr;

static bool vectors[IDT_MAX_DESCRIPTORS];
extern void* isr_stub_table[];
extern void* irq_stub_table[];

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags){
  idt_entry_t* desc = &idt[vector];

  desc->isr_low    = (uint32_t)isr & 0xffff;
  desc->kcs        = CSG;
  desc->attributes = flags;
  desc->isr_high   = (uint32_t)isr >> 16;
  desc->reserved   = 0;
}

void remap_pic(){
	uint8_t a1, a2;
	a1 = inb(0x21);
	a2 = inb(0xa1);

	outb(0x20, 0x10 | 0x01);
  outb(0xa0, 0x10 | 0x01);

	outb(0x21, 0x20);
	outb(0xa1, 0x28);
	outb(0x21, 4);
	outb(0xa1, 2);

	outb(0x21, 0x01);
	outb(0xa1, 0x01);

	outb(0x21, a1);
	outb(0xa1, a2);
}


void idt_init() {
  idtr.base = (uintptr_t)&idt[0];
  idtr.limit = (uint16_t)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

  for (uint8_t vector = 0; vector < 32; vector++) {
    idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    vectors[vector] = true;
  }

  __asm__ volatile ("lidt %0" : : "m"(idtr));

	remap_pic();
	for(uint8_t vector = 32; vector < 48; vector++){
		idt_set_descriptor(vector, irq_stub_table[vector-32], 0x8e);
		vectors[vector] = true;
	}

  __asm__ volatile ("sti");
}