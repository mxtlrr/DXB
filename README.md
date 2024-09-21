# DXB
DXB is a tiny bootable program to dump protected mode BIOS ROM onto either
1. VGA output
2. Some hard-drive via an ATA driver (note that it's up to you on how *you* 
want to recover the data).

Note that option **2** means that DXB will write **raw bytes**, not any
FAT formatted partition.

# Where Even is BIOS ROM?
It actually *depends* on the CPU!
| CPU |        Location         |
| --- | ----------------------- |
| 286 | `0xf00000-0xffffff`     |
| 386+| `0xfff00000-0xffffffff` |

DXB checks if you're running off a 286 or a 386+ and will modify it's
functions accordingly.

# Accquiring DXB
The most stable release should be in the
[Releases](https://github.com/mxtlrr/DXB/releases) tab. Grab it from there.
If none exist/you want "cutting edge", read the next section.

## Building From Source
Dependencies are:
- `i386-elf-*` (GCC crosscompiler). This is likely in your package manager.
- `nasm` (assembler).
- GRUB dependencies
  - `grub-pc-bin` (Debian-based only)
  - `xorriso`
  - `mtools`

Then you just run `make`. Output is `dxb.iso`.