AS  := nasm

all: dxb
.PHONY: all

dxb:
	@mkdir -p bin/
	@echo AS dxb.asm
	@$(AS) -g -fbin -Iinclude/ src/dxb.asm -o bin/dxb.img

clean:
	rm -rf bin/ *.img *.iso iso/


iso:
	@echo Building floppy disk...
	@dd if=/dev/zero of=dxb.img bs=512 count=2880
	@dd if=bin/dxb.img of=dxb.img conv=notrunc
	@echo Done! Generating ISO file...
	@mkdir -p iso/
	@cp dxb.img iso/
	@mkisofs -o dxb.iso -V DXB -b dxb.img iso/ || exit
	@echo Done!