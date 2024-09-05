;; Check if a floppy disk other than the one we're booting
;; on even exists.
;; Return code is in SI,
;;    0 -> No such device
;; Else, SI will point to the drive number. (this will
;; probably just be 0x01)
newFloppyExist:
  xor si, si

  mov ah, 00h
  mov dl, 01h
  int 0x13    ;; Force controller to recalibrate drive 1, which
              ;; is second floppy
  jc .Ret0

  cmp ah, 0
  jne .Ret0

  ;; Neither? Move DL to 1
  movzx si, dl
  ret

  .Ret0:
    mov si, 0
    ret