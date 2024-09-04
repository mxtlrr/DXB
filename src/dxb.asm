[org 0x7c00]

;; https://wiki.osdev.org/Memory_Map_(x86)#Overview
BIOS_START equ 0x000F0000
BIOS_MAX   equ 0x000FFFFF

BIOS_SIZE equ BIOS_MAX - BIOS_START   ;; 64 KiB


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

;; Let's first setup a handler for a #UD, so I don't
;; tear my hair out over it in the future.
UD2_EX_IRQ equ 0x0018

cli
  mov word [UD2_EX_IRQ], ud2_isr
  mov [UD2_EX_IRQ+2], ax
sti

;; Sweet! We can now do stuff.
xor ax, ax
mov ax, BIOS_START ;; See README.md, section "reading physical bytes"
mov es, ax
xor di, di    ;; DI is the n-th byte.

;; TODO: check if external disk exists.

Loop:
  cmp di, BIOS_SIZE
  je Exit

  mov cx, [es:di]   ;; CX has the actual byte at ES:DI
  mov bx, cx
  call printh
  write_space

  inc di
  jmp Loop    ;; Keep going:)

Exit:
jmp $

ud2_isr:
  pop ax      ;; AX => EIP
  mov bx, str1
  call printf

  mov bx, ax
  call printh

  hcf

str1: db `UD2 at `, 0
%include "util.asm"

times 510-($-$$) db 0
dw 0xaa55