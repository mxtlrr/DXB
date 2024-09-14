[org 0x7c00]

%macro hcf 0
  cli
  hlt
  jmp $
%endmacro

mov ax, 0x0204    ;; Read 4 sectors
mov bx, 7e00h     ;; C code located here
mov cx, 0x00002
mov dh, 0x00
int 0x13
jc .Failure
jnc 0x7e00

;; Returned? Quit.
hcf
jmp $

.Failure:
  mov ax, 0x0e5a
  int 0x10
  hcf

times 510-($-$$) db 0
dw 0xaa55
