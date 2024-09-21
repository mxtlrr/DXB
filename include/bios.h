#pragma once

#include <stdint.h>
#include <stddef.h>

/* Where's the BIOS ROM? */
enum BIOS_ROM_LOCATION {
  i286_loc = 0xf00000,
  i386_loc = 0xfff00000
};

enum CPUs {
  I286 = 0,
  I386 = 1
};

#define BIOS_ROM_SIZE 0xFFFFF // 1,048,575 bytes -- 1 mb