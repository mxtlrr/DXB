[org 0x7c00]

%macro hcf 0
  cli
  hlt
  jmp $
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


;; Now we can do other stuff:)

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