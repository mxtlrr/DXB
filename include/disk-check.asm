writeSector:
  mov al, dh
  call print_byte

  push es
  xor ax, ax
  mov es, ax
  ;; BX already buffer
  
    mov ah, 0x03    ;; Hey, we want to write!
    mov al, 0x01    ;; Only one sector
    mov cl, dh      ;; High of DX is sector number
    mov dh, 0       ;; DH already set to CL, trash it now
    ;; DL already set by BIOS
    ;; ES:BX set above
    int 0x13
    jc .Failure
    jnc .Success
    ret

  pop es
  ret

  .Failure:
    mov ah, 0x01
    ;; DL set
    int 0x13

    mov al, ah
    call print_byte
    hcf
  
  .Success:
    mov bx, wrote
    call printf
    pop es
    ret

wrote: db `I wrote data:)\r\n`, 0