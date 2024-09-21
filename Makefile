LINK 	 	 := linker.ld
LDFLAGS	 := -ffreestanding -O2 -nostdlib

OBJS := $(wildcard obj/*)

all:
	mkdir -p obj/ bin/
	nasm -felf32 src/boot/stub.asm -o obj/stub.o
	make -C src/dxb || exit
	i386-elf-gcc -T$(LINK) -o bin/dxb.bin $(LDFLAGS) $(OBJS) -lgcc || exit
	@./build_iso.sh

clean:
	rm -rf obj/ bin/ iso
