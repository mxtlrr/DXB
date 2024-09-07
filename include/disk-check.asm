writeSector:
  push es
    xor ax, ax
    mov es, ax
  ;; BX already buffer
  
    mov ah, 0x03    ;; Hey, we want to write!
    mov al, 0x01    ;; Only one sector
    mov cl, dh
    mov dh, 0       ;; DH already set to CL, trash it now
    ;; DL already set by BIOS
    ;; ES:BX set above
    int 0x13
    jc .Failure

    ;; Indicator
    mov bx, wrote
    call printf
  pop es
  ret

  .Failure:
    mov ax, 0x0e5a
    int 0x10
    hcf

wrote: db `I wrote data:)\r\n`, 0