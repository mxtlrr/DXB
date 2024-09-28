# DXB
DXB is a tiny bootable program to dump protected mode BIOS ROM onto either
1. VGA output
2. Some disk (see [this section](#what-kind-of-disk-can-i-use) for 
more info on supported disk types.)

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

# Usage
## The User Interface
TODO

## Running in QEMU
The `qemu.sh` script will help with this. If a file named `disk.img` does
not exist, it will create it, with the size of `512x65535` bytes (approx.
32MB), which is **way** more than required for this.

Then, it'll run QEMU with:
- The DXB image script as the master drive (index=0)
- The previously made hard disk as the slave (index=1),

both as IDE, as IDE works with ATA (which is currently what is supported).

## What kind of disk can I use?
Currently, DXB only supports ATA disks. Soon, it'll support:
- ATAPI (CD/DVD-ROM)
- SATA (extensions to ATA)

Note that it'll be a while for *full* support of all those above.
I'll get to it. Eventually.