writeSector:
  cmp ch, 3     ;; Track 2 will have sectors 126 to 189.
  je .Maybe     ;; Don't overwrite ourselves!

  cmp dh, 63
  jg .Fix     ;; AH=03h doesn't support bigger than 63. Fucking stupid.
              ;; Fuck BIOS.

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

  .Fix:
    mov ax, 0x0e66
    int 0x10


    inc ch      ;; Next track/cylinder!
    xor dh, dh  ;; Reset DH/sector number.
    mov cl, dh
    ;; Don't fall through.
    ret

  .Failure:
    ;; DL already set
    mov ah, 0x01
    int 0x10
    hcf

  .Maybe:
    jmp $
    cmp dh, 5   ;; 126+5 => 131, we only want to write up to sector
                ;; 131.
    je Exit
    ret   ;; No? return

wrote1: db `Wrote sector `, 0
wrote2: db `\r\n`, 0