#include "disk/ata.h"

void ata_send_cmd(uint8_t cmd){
  outb(COMMAND, cmd);
}

uint8_t ata_read_status(){
  return inb(STATUS);
}

uint16_t information[256];
uint8_t ident_drive(uint8_t drive){
  // Select the drive
  outb(DRIVE_SEL, drive);
  ata_reset();

  // SectCount, Lba registers to 0
  for (int i = 0x1f2; i <= 0x1f5; i++) outb(i, 0x00);

  // Identify yourself!!
  outb(COMMAND, 0xEC);
  // ?
  // while (inb(STATUS) & CONTROLLER_EXC);
  uint8_t vv = inb(STATUS);
  if(vv == 0){
    printf("ata: drive 0x%x does not exist\n", drive);
    return NO_DEV;
  }

  uint8_t lba_mid = inb(CYLIN_LO);
  uint8_t lba_hi  = inb(CYLIN_HI);
  if(lba_mid == lba_hi && lba_hi == 0x00){
    printf("ata: drive 0x%x identified as ATA\n", drive);
  }
  
  if(lba_mid == 0x14 && lba_hi == 0xEB){
    // TODO: figure out if I can still use ATA stuff with ATAPI.
    // This also means that the device we're using is some CD-ROM
    // or DVD-ROM.
    printf("ata: drive 0x%x identified as ATAPI (CD-ROM/DVD-ROM)\n", drive);
    return ATAPI_DEV;
  } else if(lba_mid == 0x3c && lba_hi == 0xc3){
    // Out of scope of this driver. Someday I'll write a
    // SATA driver, but that's not yet.
    printf("ata: drive 0x%x identified as SATA\n");
    return SATA_DEV;
  }

  // Read 256x16 from data port. Don't know if this is optional
  // or not.
  for (int i = 0; i < 256; i++) information[i] = inw(DATA_REG);

  // Still here? Return ATA
  return PATA_DEV;
}

void ata_reset() {
  outb(0x3f6, 0x04);
  io_wait();
  outb(0x3F6, 0x00);
  while (inb(0x1F7) & (1 << 7)) io_wait();
}