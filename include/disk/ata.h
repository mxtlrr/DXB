#pragma once

#include <stddef.h>
#include <stdint.h>

#include "io.h"
#include "libc/stdio.h"

#define MASTER_DRIVE 0xa0
#define SLAVE_DRIVE  0xb0

enum ATA_REGISTERS {
  DATA_REG = 0x1f0,   /* Data register */
  ERR_REG  = 0x1f1,   /* Error register */
  SECT_CT  = 0x1f2,   /* How many sectors to read/write */
  SECT_NUM = 0x1f3,   /* Actual sector wanted */
  CYLIN_LO = 0x1f4,   /* Cylinders 0 through 1024, low */
  CYLIN_HI = 0x1f5,   /* Last 1024 of drive/head */
  DRIVE_SEL= 0x1f6,   /* Drive/head, see below. */
  STATUS   = 0x1f7,   /* Status, read only. */
  COMMAND  = 0x1f7    /* Command register. Write only. */
};


/* What can we read from the status register? */
enum STATUS_BYTES {
  CONTROLLER_EXC = (1<<7),   /* Controller executing a command */
  DRIVE_READY    = (1<<6),   /* The drive is ready! */
  WRITE_FAULT    = (1<<5),   /* Faulty write command? */
  SEEK_COMPLETE  = (1<<4),   /* ... */
  SECT_BUFF_SV   = (1<<3),   /* Sector buffer requires serivicing */
  DISK_RD_CORR   = (1<<2),   /* Disk data read was corrected */
  INDEX_         = (1<<1),   /* Set to 1 each revolution. */
  PREV_CMD_ERR   = (1<<0)    /* Previous command ended in error*/
};

/* Stuff that's supported to send to the command byte */
enum COMMAND_BYTES {
  FORMAT_TRACK    = 0x50,
  READ_SECTORS_WR = 0x20,   /* Read sectors with retry    */
  READ_SECTORS_NR = 0x21,   /* Read sectors with no retry */
  READ_LONG_WR    = 0x22,   /* Read long with retry       */
  READ_LONG_NO_R  = 0x23,   /* Read long with no retry    */
  WRITE_SECT_NO_R = 0x30,
  WRITE_SECT_WR   = 0x31,
  WRITE_LONG_NO_R = 0x32,
  WRITE_LONG_WR   = 0x33
};

// Read from the ATA status register.
uint8_t ata_read_status();

// Send a command to the ATA controller
void ata_send_cmd(uint8_t cmd);

uint8_t ident_drive(uint8_t drive);


void ata_handle_err();
void ata_reset();

/* Return values from ident_drive */
#define ATAPI_DEV 0xAF
#define PATA_DEV  0x00    /* This is what we want! */
#define SATA_DEV  0xEB    /* Eventually I'l write a drier for this... */
#define NO_DEV    0xFF

/* Stuff returned from a typical ATA write/read. */
typedef struct {
  uint8_t  status_code; // See below
  uint16_t sector_data[256];
} ata_packet_t;

#define STATUS_CODE_SUCCESS 0x00
#define STATUS_CODE_FAILURE 0x01

/* Note that sector 0 will NOT work! You will have to use
 * a sector (>=1).*/
ata_packet_t read_sector(uint8_t drive, uint16_t sector);