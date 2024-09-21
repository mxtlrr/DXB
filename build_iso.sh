#!/bin/bash
rm -rf iso/
sleep 0.1
mkdir -p iso/boot/grub
cp bin/dxb.bin iso/boot/dxb.bin
cp src/boot/grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o dxb.iso iso
