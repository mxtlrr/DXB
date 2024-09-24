#!/bin/bash
ls disk.img || dd if=/dev/zero bs=512 count=65535 of=disk.img
qemu-system-i386 -drive file=dxb.iso,media=cdrom,if=ide,index=0 \
       -drive file=disk.img,if=ide,index=1