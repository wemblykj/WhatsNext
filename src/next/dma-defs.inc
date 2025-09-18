; -----------------------------------------------------------
; File:        dma-defs.inc
; Project:     WhatsNext - DMA Routines
; Description: Equates and constants for the ZX Spectrum Next
;              DMA controller, as per the official documentation:
;              https://wiki.specnext.dev/DMA
; Author:      Paul Wightmore. (c) 2025
; License:     MIT License
; -----------------------------------------------------------

; -----------------------------------------------------------
; DMA PORT CONSTANTS
; -----------------------------------------------------------
DMA_PORT_MB02         equ 0x0B    ; MB02 DMA port (legacy)
DMA_PORT_DATAGEAR     equ 0x6B    ; Datagear DMA port (ZX Next default)
DMA_PORT_NEXT         equ DMA_PORT_DATAGEAR ; Default Next DMA port

; -----------------------------------------------------------
; DMA PORT TYPE CONSTANTS
; Used for both source and destination in DMA transfers.
; -----------------------------------------------------------
DMA_PORTTYPE_MEM      equ %00     ; Port is memory/address (as per Next docs)
DMA_PORTTYPE_IO       equ %01     ; Port is I/O

; -----------------------------------------------------------
; DMA ADDRESS MODE CONSTANTS
; -----------------------------------------------------------
DMA_ADDRH_DEC         equ %00     ; Address decrements after transfer
DMA_ADDRH_INC         equ %01     ; Address increments after transfer
DMA_ADDRH_FIXED       equ %10     ; Address remains fixed

; -----------------------------------------------------------
; DMA TIMING CONSTANTS
; -----------------------------------------------------------
DMA_TIMING_4          equ %00     ; 4 T-states per cycle (default)
DMA_TIMING_3          equ %01     ; 3 T-states per cycle
DMA_TIMING_2          equ %10     ; 2 T-states per cycle

; -----------------------------------------------------------
; DMA MODE CONSTANTS
; -----------------------------------------------------------
DMA_MODE_CONTINUOUS   equ %01     ; Continuous transfer mode
DMA_MODE_BURST        equ %10     ; Burst transfer mode

; -----------------------------------------------------------
; DMA COMMAND CONSTANTS (for WR6)
; -----------------------------------------------------------
DMA_COMMAND_ENABLE    equ %00001  ; Enable DMA
DMA_COMMAND_DISABLE   equ %00000  ; Disable DMA
DMA_COMMAND_READMASK  equ %01110  ; Read mask register
DMA_COMMAND_LOAD      equ %10011  ; Load DMA program
DMA_COMMAND_CONTINUE  equ %10100  ; Continue DMA program

; -----------------------------------------------------------
; INTERNAL BIT MASKS AND SHIFTS (for macro use only)
; -----------------------------------------------------------
DMA_WR0_MASK           equ %01111100
DMA_WR0_STATIC         equ %00000001
DMA_WR0_LSB            equ 2

DMA_WR1_MASK           equ %01111000
DMA_WR1_STATIC         equ %00000100
DMA_WR1_LSB            equ 3
DMA_WR1_TIMING_MASK    equ %00000011
DMA_WR1_TIMING_STATIC  equ %00000000
DMA_WR1_TIMING_LSB     equ 0

DMA_WR2_MASK           equ %01111000
DMA_WR2_STATIC         equ %00000000
DMA_WR2_LSB            equ 3
DMA_WR2_TIMING_MASK    equ %01100011
DMA_WR2_TIMING_STATIC  equ %00000000
DMA_WR2_TIMING_LSB     equ 0

DMA_WR3_MASK           equ %01000000
DMA_WR3_STATIC         equ %10000000
DMA_WR3_LSB            equ 6

DMA_WR4_MASK           equ %01101100
DMA_WR4_STATIC         equ %10000001
DMA_WR4_LSB            equ 2

DMA_WR5_MASK           equ %00110000
DMA_WR5_LSB            equ 4
DMA_WR5_STATIC         equ %10000010

DMA_WR6_MASK           equ %01111100
DMA_WR6_STATIC         equ %10000011
DMA_WR6_LSB            equ 2

DMA_WR6_READMASK_MASK   equ %01111111
DMA_WR6_READMASK_STATIC equ %10000000

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------