#pragma once

#include "libc/stdio.h"
#include "arch/idt.h"

uint8_t get_op(uint32_t place);
void exception_handler(registers_t* r);