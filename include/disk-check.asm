writeSector:
  push es
  xor ax, ax
  mov es, ax

  ;; Write data?
  mov ah, 0x03
  mov al, 0x01
  ;; CH already set.
  mov cl, dh    ;; Save sector data in CL
  mov dh, 0     ;; Head 0
  ;; DL already set
  ;; BX already set before calling
  int 0x13

  ;; Restore DH
  mov dh, cl

  mov al, dh
  call print_byte

  cmp ch, 3     ;; Track 2 will have sectors 126 to 189.
  je .Maybe     ;; Don't overwrite ourselves!

  cmp dh, 63
  je .Fix     ;; AH=03h doesn't support bigger than 63. Fucking stupid.
              ;; Fuck BIOS.

  jmp .Bye

  .Fix:
    inc ch
    xor dh, dh

    write_space
    jmp .Bye

  .Failure:
    ;; DL already set
    mov ah, 0x01
    int 0x13
    hcf

  .Maybe:
    cmp dh, 5   ;; 126+5 => 131, we only want to write up to sector
                ;; 131.
    je Exit
    
  .Bye:
    pop es
    ret

wrote1: db `Wrote sector `, 0
wrote2: db `\r\n`, 0