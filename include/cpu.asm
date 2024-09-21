[GLOBAL check_386]
check_386:
  pushfd
  pop eax
  mov ecx, eax

  xor eax, 0x40000
  push eax
  popfd

  pushfd
  pop eax

  xor eax, ecx
  jz .i286

  mov eax, 1
  ret

  .i286:
    xor eax, eax
    ret