# DXB
DXB is a tool to dump BIOS ROM/RAM either onto a disk or onto VGA output.
TODO...

# Screenshots
TODO...

# Building/Compiling DXB
You'll need NASM (stub) and ia16-elf-gcc. Once you're sure you have
both of those, you can just run `make`.

### Acquiring IA16-ELF-GCC
Run `./tool.sh ia16-elf`.

# Using DXB
## QEMU
TODO.

## Running on real hardware
Just run `make iso`. Note that this generates a `1.44` MB floppy image,
as `dxb.img`. You can flash it to a USB like so:
```sh
# We are assuming /dev/sdc is:
#   1. Blank
#   2. Your USB
$ sudo dd if=dxb.img of=/dev/sdc
```

# Accessing the data

## Step 1: Getting Raw Data
Luckily for us, we don't have to write any weird scripts, and `dd` is
available on most *NIX systems. So, we can do something like this:
```sh
SECTOR_COUNT=130    # Sector 0: DXB code
                    # Sector 1: Padding
                    # Sector 2-130: BIOS ROM
SECTOR_SIZE=512
USB_BUS=/dev/sdc

$ sudo dd if=$(USD_BUS) bs=$(SECTOR_SIZE) count=$(SECTOR_COUNT) of=raw.bin
```

## Step 2: Grabbing the sectors
Again, we will use a built-in program to do this, in our case, this is
`tail`:
```sh
# 128 sectors X 512 bytes per sector ==> 65536.
$ tail -c 65536 raw.bin > bios.fd
```

## Step n: What's Next?
If every command above worked, then `bios.fd` has the raw BIOS firmware
of whatever provider you used. Now you can dissasemble it with
```
objdump -b binary -m i386 -D bios.fd
```

or, something else! It's up to you.

# Contributing
The IA16-elf ABI documentation can be found [here](https://mpetch.github.io/ia16-gcc-6.3.0/gcc/index.html).