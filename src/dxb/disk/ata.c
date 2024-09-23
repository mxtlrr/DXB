#include "disk/ata.h"

void ata_send_cmd(uint8_t cmd){
  outb(COMMAND, cmd);
}

uint8_t ata_read_status(){
  return inb(STATUS);
}

uint16_t information[256];
void ident_drive(uint8_t drive){
  // Select the drive
  outb(DRIVE_SEL, drive);

  ata_reset();

  // SectCount, Lba registers to 0
  for (int i = 0x1f2; i <= 0x1f5; i++) outb(i, 0x00);

  // Identify yourself!!
  outb(COMMAND, 0xEC);
  while (inb(STATUS) & CONTROLLER_EXC);

  uint8_t lba_mid = inb(CYLIN_LO);
  uint8_t lba_hi  = inb(CYLIN_HI);
  if(lba_mid == 0x14 && lba_hi == 0xEB){
    // TODO: figure out if I can still use ATA stuff with ATAPI.
    // This also means that the device we're using is some CD-ROM
    // or DVD-ROM.
    printf("ata: drive 0x%x identified as ATAPI (CD-ROM/DVD-ROM)\n", drive);
    return;
  } else if(lba_mid == 0x3c && lba_hi == 0xc3){
    // Out of scope of this driver. Someday I'll write a
    // SATA driver, but that's not yet.
    printf("ata: drive 0x%x identified as SATA\n");
    return;
  }
  // Poll until the drive is ready
  uint8_t b;
  while ((b = inb(STATUS)) & CONTROLLER_EXC) {
    printf("Hi\n");

    // Stop polling if LBAmid or LBAhi is non-zero 
    if(lba_mid == lba_hi && lba_hi == 0x00){
      printf("ata: drive 0x%x is valid ATA\n");
      break;
    } else {
      printf("ata: unknown drive type on 0x%x. lba_mid=%x, lba_hi=%x\n",
          drive, lba_mid, lba_hi);
    }

    // Stop polling if bit 3 or bit 0 are set
    if ((b & SECT_BUFF_SV) != 0 || (b & PREV_CMD_ERR) != 0) {
      printf("ata: bit 3:%x\nata: bit 0 -> %x\n", (b & SECT_BUFF_SV),
              (b & PREV_CMD_ERR));
      break;
    }

    b = inb(STATUS);
  }

  // Did an error occur?
  if (b & PREV_CMD_ERR) {
    printf("ata: previous command resulted in error -- Error code: 0x%x\n",
        inb(ERR_REG));
    return;
  }

  // Read 256x16 from data port
  for (int i = 0; i < 256; i++) information[i] = inw(DATA_REG);
  printf("ata: finished reading\n");

  // Print out interesting data
  printf("ata: short 0: %x\nata: LBA48 enabled? %s\n",
          information[0],
          (information[83] & LBA48_ALLOWED) ? "yes" : "no");
}

void ata_reset() {
  outb(0x3f6, 0x04);
  io_wait();
  outb(0x3F6, 0x00);
  while (inb(0x1F7) & (1 << 7)) io_wait();
}