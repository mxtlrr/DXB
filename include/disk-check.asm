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

    ;; Restore DH
    mov dh, cl

    ;; Indicator
    mov al, dh
    call print_byte

  pop es
  ret

  .Failure:
    mov ax, 0x0e5a
    int 0x10

    ;; DL already set
    mov ah, 0x01
    int 0x10
    hcf

wrote1: db `Wrote sector `, 0
wrote2: db `\r\n`, 0