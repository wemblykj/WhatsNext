; -----------------------------------------------------------
; File:        dma-vars.inc
; Project:     WhatsNext - DMA Routines
; Description: Working variables, buffers, and persistent data
;              used by DMA routines. Place in DATA segment.
;              This file defines a generic DMA program block
;              for the ZX Spectrum Next DMA controller.
;              Variable fields (source, destination, length)
;              are labeled for external modification.
; Author:      Paul Wightmore. (c) 2025
; License:     MIT License
; -----------------------------------------------------------

; -----------------------------------------------------------
; SECTION: DMA Generic Program Block Definition
; -----------------------------------------------------------
; This block defines a reusable DMA program for a generic
; memory-to-memory transfer. The program can be patched, at 
; the labeled addresses before uploaded to the DMA registers.
; The patchable fields are:
;   - DMA_PROGRAM_BLOCK_SOURCE:      WR0 Port A (source address)
;   - DMA_PROGRAM_BLOCK_LENGTH:      WR0 Block length (bytes)
;   - DMA_PROGRAM_BLOCK_DEST:        WR4 Port B (destination address)
; The program disables DMA, sets up all registers, loads the
; program, and enables DMA.
; 
; Externally referenced symbols:
;   DMA_PROGRAM_CONFIG           - Start address of the configuration program
;   DMA_PROGRAM_RESTART          - Start address of the restart program
;
;   DMA_PROGRAM_CONFIG_LEN       - Length of the config program
;   DMA_PROGRAM_UPLOAD_LEN       - Length of the config and upload program
;   DMA_PROGRAM_ONLY_LEN         - Length of the restart program
;
;   DMA_PROGRAM_CONFIG_SOURCE     - Patchable source address field
;   DMA_PROGRAM_CONFIG_LENGTH     - Patchable block length field
;   DMA_PROGRAM_CONFIG_DEST       - Patchable destination address field
; -----------------------------------------------------------

DMA_PROGRAM_CONFIG:    ; Start of DMA program block (for upload)
    DMA_WR6 DMA_COMMAND_DISABLE, -1                     ; WR6: Disable DMA
    DMA_WR0_BASE 1, 1, 1, 1, 1                          ; WR0: A-to-B transfer, Port A LSB/MSB, Block length LSB/MSB
DMA_PROGRAM_CONFIG_SOURCE:      dw 0                    ; Patch: WR0 Port A (source address, 16-bit)
DMA_PROGRAM_CONFIG_LENGTH:      dw 0                    ; Patch: WR0 Block length (16-bit, bytes)
    DMA_WR1 DMA_PORTTYPE_MEM, DMA_ADDRH_INC, DMA_TIMING_4 ; WR1: Port A config & timing (memory, increment, 4T)
    DMA_WR2 DMA_PORTTYPE_MEM, DMA_ADDRH_INC, DMA_TIMING_4, 0 ; WR2: Port B config & timing (memory, increment, 4T, prescaler 0)
    DMA_WR4_BASE 1, 1, DMA_MODE_CONTINUOUS              ; WR4: Port B timing and continuous mode
DMA_PROGRAM_CONFIG_DEST:        dw 0                    ; Patch: WR4 Port B (destination address, 16-bit)
    DMA_WR5 0, 0                                        ; WR5: Ready/Stop config (not used)
DMA_PROGRAM_CONFIG_END: 
DMA_PROGRAM_RESTART:                                    ; Reload internal registers and restart
    DMA_WR6 DMA_COMMAND_LOAD, -1                        ; WR6: Load program
    DMA_WR6 DMA_COMMAND_ENABLE, -1                      ; WR6: Enable DMA
DMA_PROGRAM_END:                                        ; End of DMA program block (for length calculation only)

DMA_PROGRAM_CONFIG_LEN   equ DMA_PROGRAM_CONFIG_END - DMA_PROGRAM_CONFIG     ; Length in bytes (for config only)
DMA_PROGRAM_UPLOAD_LEN   equ DMA_PROGRAM_END - DMA_PROGRAM_CONFIG            ; Length in bytes (for config & upload)
DMA_PROGRAM_RESTART_LEN  equ DMA_PROGRAM_END - DMA_PROGRAM_RESTART           ; Length in bytes (for restart only)

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------