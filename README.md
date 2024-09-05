# DXB
DXB dumps the BIOS ROM/RAM onto an external disk. If it cannot find any disks, then it will output
the ROM/RAM to the screen, in hex.

The BIOS ROM/RAM is located at physical address `0x000F0000`, and is 64kb (65535 bytes) wide. DXB
first:
1. Checks to see if there are more than one floppy (USB emulates floppy).
If it doesn't find any, it will just output to the screen.
2. It setups up segmentation `ES=0x0000F000, BX=0`
3. Reads every byte at memory address `[ES:BX]` until `BX=0xFFFF`.

## How do you read the physical bytes?
Segmentation in 16-bit real mode is

$$
P_a = (16r_s) + O,
$$

where $P_a$ is the physical address, $r_s$ is the value of the segment
register, and $O$ is the offset. For our case,

$$
P_a = 16(\text{F}000_{16}) + n = \boxed{\text{F}000_{16} + n},
$$

$n$ being the $n$-th byte we want to read, and the $16$ subscript denoting
that the number is in base 16. An example of this follows.

Let's say we want to read the $20$-th byte of the ROM. We just substitute
$20$ in, like so:

$$
\text{F}000_{16} + 14_{16},
$$

giving us $P_a = \text{F}014_{16} = 983060_\text{10}$. Segmentation in
this use case is very useful for accessing values greater than the limits
of the registers we limit ourselves to -- that being $65535$.

# Building/Compiling DXB
You'll need NASM. For right now, everything is written in real-mode x86
assembly. I'd like to get C on bare-metal IA16 but I've yet to figure out
how to do that with ia16-elf-gcc.

All you need to do is run `make`, which invokes the build script to
compile the program. The output will be in `bin`

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

# What's Planned?
1. Somehow write to a FAT formatted partition (on said external drive
I mentioned earlier), not just writing raw sectors (requires $128$
sectors to be written to disk)
2. Better user interface.
