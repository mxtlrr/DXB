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
  ret

printh:
  push ax
  push bx
  push cx

  mov ah, 0Eh

  mov al, '0'
  int 0x10
  mov al, 'x'
  int 0x10

  mov cx, 4

  printh_loop:
    cmp cx, 0
    je printh_end

    push bx

    shr bx, 12

    cmp bx, 10
    jge printh_alpha

    mov al, '0'
    add al, bl

    jmp printh_loop_end

    printh_alpha:
      sub bl, 10
      
      mov al, 'A'
      add al, bl

    printh_loop_end:
      int 0x10

      pop bx
      shl bx, 4

      dec cx

      jmp printh_loop

printh_end:
  pop cx
  pop bx
  pop ax

  ret


;; Write a byte to output.
;; Input:
;;  AL -> byte
;; Source: https://stackoverflow.com/a/49846973
print_byte:
  push ax
  shr al, 0x04
  call .nibble
  pop ax
  and al, 0x0F
  call .nibble
  ret
  .nibble:
    cmp al, 0x09
    jg .letter
    add al, 0x30
    mov ah, 0x0E
    int 0x10
    ret

  .letter:
    add al, 0x37
    mov ah, 0x0E
    int 0x10
    ret   
