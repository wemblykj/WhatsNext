; -----------------------------------------------------------
; File:        dma-lib.asm
; Project:     WhatsNext - DMA Routines
; Author:      Paul Wightmore
; Date:        2025-09-18
; Description: Z80 sjasmplus compatible DMA library routines
;              for the ZX Spectrum Next. Provides routines to
;              patch and upload a generic DMA program block.
;              See: https://wiki.specnext.dev/DMA
; 
;              This module depends on dma-vars.inc being
;              included beforehand, as it uses the DMA program
;              block and patchable labels defined there.
; License:     MIT License
; -----------------------------------------------------------

; -----------------------------------------------------------
; DMA_UPLOAD
; Uploads a DMA program block to the DMA controller.
; Parameters:
;   hl = address of program block
;   b  = length of program block (bytes)
; Uses:
;   c  = DMA port (set to DMA_PORT_NEXT)
; -----------------------------------------------------------
DMA_UPLOAD:
    ld  c, DMA_PORT_NEXT                  ; Set DMA data port (ZX Next default)
    otir                                  ; Output program block to DMA data port
    ret

; -----------------------------------------------------------
; DMA_BLOCK_TRANSFER
; Patches the generic DMA program block with the given source,
; destination, and length, then uploads it to the DMA controller.
; Parameters:
;   hl = source address (16-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DMA_BLOCK_TRANSFER:
    ld  (DMA_PROGRAM_CONFIG_SOURCE), hl    ; Patch source address in program block
    ld  (DMA_PROGRAM_CONFIG_LENGTH), bc    ; Patch block length in program block
    ld  (DMA_PROGRAM_CONFIG_DEST), de      ; Patch destination address in program block
    ld  hl, DMA_PROGRAM_CONFIG             ; Load start address of program block
    ld  b, DMA_PROGRAM_UPLOAD_LEN          ; Load length of program block
    jr  DMA_UPLOAD

; -----------------------------------------------------------
; DMA_BLOCK_SET
; And patches the DMA program block to copy length-1 bytes from
; the destination address to destination address + 1.
; This results in a block of memory being set to the give value.
; Parameters:
;   a  = value to set (8-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DMA_BLOCK_SET:
    ld  hl, de
    ld  (hl), a
    inc de
    dec bc
    jr  DMA_BLOCK_TRANSFER

; -----------------------------------------------------------
; DMA_BLOCK_SET
; And patches the DMA program block to copy length-1 bytes from
; the destination address to destination address + 1.
; This results in a block of memory being set to the give value.
; Parameters:
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DMA_BLOCK_CLEAR:
    xor a
    jr  DMA_BLOCK_SET

; -----------------------------------------------------------
; DMA_BLOCK_TRANSFER
; Patches the generic DMA program block with the given source,
; destination, and length, then uploads it to the DMA controller.
; Parameters:
;   hl = source address (16-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DMA_RESTART:
    ld  hl, DMA_PROGRAM_RESTART    ; Load start address of program block
    ld  b, DMA_PROGRAM_RESTART_LEN          ; Load length of program block
    jr  DMA_UPLOAD

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------