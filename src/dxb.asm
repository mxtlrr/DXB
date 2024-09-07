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

%include "disk-check.asm"


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
mov es, ax    ;; Set ES to segment 0, disk writing

mov ax, 61440 ;; Point FS to physical memory location
mov fs, ax

xor di, di
mov cx, 3
mov si, 0

WriteToDisk:
  cmp di, 512
  je .Reset

  mov al, [fs:si]
  mov byte [buffer+di], al

  inc di
  jmp WriteToDisk

  .Reset:
    push di
    cmp si, BIOS_SIZE   ;; End?
    je Exit

    ;; Write to disk
    write_sector 1, cl, buffer
    ; push bx
    ;   xor bx, bx
    ;   mov es, bx
    ; pop bx
    ; mov bx, buffer
    ; call writeSectorData

    inc cx
    xor di, di

    ;; Reset buffer
    mov di, 0
    .StupidLoop:
      cmp di, 512
      je .Leave

      mov [buffer+di], byte 0
      inc di
      jmp .StupidLoop
    .Leave:
      xor di, di
      pop di
  jmp WriteToDisk


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

%include "util.asm"

times 510-($-$$) db 0
dw 0xaa55

buffer times 512 db 0