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

;; Check if we're on 386.
;; Won't support 286 for now.
push sp
pop ax
cmp ax, sp
jne .No386    ;; 286.

;; MSW bits 15->4 are clear?
smsw ax
cmp ax, 0x0fff0
jae .No386   ;; is AX >= 0x0FFF0?

;; 386 is enabled!!
jmp 0x7e00

.No386:
  mov bx, string_bad286
  call printf

;; Returned? Quit.
hcf
jmp $

.Failure:
  mov bx, string_nodisk
  call printf
  hcf


printf:
  push ax
  push bx

  mov ah, 0x0e
  .Loop:
    cmp [bx], byte 0
    je .Exit

    mov al, [bx]
    int 0x10

    inc bx
    jmp .Loop
  .Exit:
    pop bx
    pop ax
  ret

string_nodisk: db `No dice! Can't read from 7e00h.`, 0
string_bad286: db `Sorry, DXB doesn't support the 80286.`, 0

times 510-($-$$) db 0
dw 0xaa55
