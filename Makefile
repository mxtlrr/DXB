# i386-elf will work too, but prefer IA16.
# You can change this with specifying the TARGET flag
TARGET ?= ia16-elf

CC := $(TARGET)-gcc
LD := $(TARGET)-ld
OC := $(TARGET)-objcopy

LDFLAGS := -static -Tlinker.ld -nostdlib --nmagic

# -fno-asynchronous-unwind-tables is SUPER important!!
CFLAGS := -Os -fno-asynchronous-unwind-tables -march=i186 -ffreestanding \
					-Wall -Wextra -Iinclude/


override CFILES := $(shell find ./src/ -type f -name '*.c')

all: dxb link
.PHONY: all

dxb:
	mkdir -p obj/ bin/
	@echo AS stub.asm
	nasm -fbin src/boot/stub.asm -o obj/stub.o

	@$(foreach file, $(CFILES), echo CC $(file); $(CC) -c $(file) $(CFLAGS) -o obj/$(basename $(notdir $(file))).o;)


override OFILES := $(shell find ./obj/ -type f -name '*.o' | awk '!/stub/')

link:	
	@mkdir -p obj/stage2
	@echo -n Linking...
	@$(LD) $(LDFLAGS) $(OFILES) -o obj/stage2/azd.elf
	@$(OC) -O binary obj/stage2/azd.elf obj/stage2/ext.img
	@cat obj/stub.o obj/stage2/ext.img > bin/dxb.img
	@echo done!
	@echo Output in bin/

clean:
	rm -rf obj/ bin/ *.img