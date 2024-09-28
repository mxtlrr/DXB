#pragma once

#include "libc/stdio.h"
#include "arch/idt.h"

uint8_t get_op(uint32_t place);
void exception_handler(registers_t* r);



typedef void (*isr_t)(registers_t*);
void irq_handler(registers_t* r);
void register_IRQ(uint8_t vector, isr_t callback);

extern isr_t handlers[256];