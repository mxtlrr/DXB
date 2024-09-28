#pragma once

#include <stdint.h>
#include <stdbool.h>

#include "io.h"

#define CSG 0x08
#define IDT_MAX_DESCRIPTORS 256

typedef struct {
  uint16_t isr_low;
  uint16_t kcs;
  uint8_t  reserved;
  uint8_t  attributes;
  uint16_t isr_high;
} __attribute__((packed)) idt_entry_t;

typedef struct {
	uint16_t	limit;
	uint32_t	base;
} __attribute__((packed)) idtr_t;

typedef struct {
	uint32_t useless_ds;    // Unused, doesn't get pushed by CPU.
	uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
	uint32_t int_no, errcode;
	uint32_t ip, cs, eflags;
} registers_t;

void remap_pic();
void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags);
void idt_init(void);