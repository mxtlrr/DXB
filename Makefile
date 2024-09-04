AS  := nasm

all: dxb
.PHONY: all

dxb:
	@mkdir -p bin/
	@echo AS dxb.asm
	@$(AS) -g -fbin -Iinclude/ src/dxb.asm -o bin/dxb.img

clean:
	rm -rf bin/