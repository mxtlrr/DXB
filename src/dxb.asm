[org 0x7c00]

;; https://wiki.osdev.org/Memory_Map_(x86)#Overview
BIOS_START equ 0x000F0000
BIOS_MAX   equ 0x000FFFFF

BIOS_SIZE equ BIOS_MAX - BIOS_START   ;; 64 KiB
BYTES_TO_READ equ 10

;; Set video mode, just in case the BIOS didn't finish setting
;; shit up
mov ax, 0x0003
int 0x10

%macro hcf 0
  cli
  hlt
  jmp $
%endmacro

%macro write_space 0
  mov ax, 0x0e20
  int 0x10
%endmacro



xor ax, ax
mov ds, ax
mov ss, ax
mov sp, 0x7c00

mov bx, splash1
call printf


;; Sweet! We can now do stuff.
xor ax, ax
mov ax, 61440 ;; See README.md, section "reading physical bytes"
mov es, ax
xor di, di    ;; DI is the n-th byte.

mov bx, splash3
call printf

mov ah, 0
int 16h

cmp al, '1'
je WriteToDisk

cmp al, '2'
je WriteOut

jne $ ;; Neither. Sorry, we don't support that!


WriteOut:
  mov bx, splash2
  call printf

  .Loop:
    cmp di, BIOS_SIZE
    je Exit

    mov cx, [es:di]   ;; CX has the actual byte at ES:DI

    ;; Write the byte to the screen.
    ;; TODO: don't do this if the external disk does exist.
    mov al, cl
    call print_byte
    write_space

    inc di
    jmp .Loop    ;; Keep going:)


xor ax, ax
mov ax, 0xF000
mov es, ax
WriteToDisk:
  mov ch, 0x00
  xor di, di
  xor si, si
  mov dh, 3   ;; Sector number
  .Loop:
    ;; 3 to 131 is 128 sectors
    ;; 128*512 = 65535 bytes,
    cmp dh, 131
    je Exit

    cmp di, 512
    je .Reset

    mov ax, [es:si]
    mov [buffer+di], al

    inc di
    inc si
    jmp .Loop
    ret

  .Reset:
    mov bx, buffer  ;; Buuff
    call writeSector


    xor di, di
    inc dh
    jmp .Loop

Exit:
  mov bx, splash4
  call printf
  jmp $


failed_op:
  call print_byte
  cli
  hlt
  jmp $

splash1: db `Welcome to DXB!\r\n`, 0
splash2: db `Printing out!\r\n`, 0
splash3: db `Press 1 to write, press 2 to output.\r\n`, 0
splash4: db `Done!\r\n`, 0

%include "disk-check.asm"
%include "util.asm"

times 510-($-$$) db 0
dw 0xaa55

buffer times 512 db 0x00