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
; DmaUpload
; Uploads a DMA program block to the DMA controller.
; Parameters:
;   hl = address of program block
;   b  = length of program block (bytes)
; Uses:
;   c  = DMA port (set to DMA_PORT_NEXT)
; -----------------------------------------------------------
DmaUpload:
    ld  c, DMA_PORT_NEXT                  ; Set DMA data port (ZX Next default)
    otir                                  ; Output program block to DMA data port
    ret

; -----------------------------------------------------------
; DmaBlockTransfer
; Patches the generic DMA program block with the given source,
; destination, and length, then uploads it to the DMA controller.
; Currently only configured for memory-to-memory transfers.
; Parameters:
;   hl = source address (16-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DmaBlockTransfer:
    ld  (DMA_PROGRAM_CONFIG_SOURCE), hl    ; Patch source address in program block
    ld  (DMA_PROGRAM_CONFIG_LENGTH), bc    ; Patch block length in program block
    ld  (DMA_PROGRAM_CONFIG_DEST), de      ; Patch destination address in program block
    ld  hl, DMA_PROGRAM_CONFIG             ; Load start address of program block
    ld  b, DMA_PROGRAM_UPLOAD_LEN          ; Load length of program block
    jr  DmaUpload

; -----------------------------------------------------------
; DmaMemCopy
; Copy length bytes from source to destination.
; Parameters:
;   hl = source address (16-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DmaMemCopy: equ DmaBlockTransfer           ; Just an alias for [mem only] block transfer for now

; -----------------------------------------------------------
; DmaMemSet
; Set length bytes, starting at destination, to the given value.
; Parameters:
;   a  = value to set (8-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DmaMemSet:
    ld  hl, de
    ld  (hl), a
    inc de
    dec bc
    jr  DmaMemCopy

; -----------------------------------------------------------
; DmaZeroMem
; Zero length bytes starting at destination.
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DmaZeroMem:
    xor a
    jr  DmaMemSet

; -----------------------------------------------------------
; DmaRestart
; Patches the generic DMA program block with the given source,
; destination, and length, then uploads it to the DMA controller.
; Parameters:
;   hl = source address (16-bit)
;   de = destination address (16-bit)
;   bc = length of data (16-bit, bytes)
; Uses patchable fields and program block from dma-vars.inc
; -----------------------------------------------------------
DmaRestart:
    ld  hl, DMA_PROGRAM_RESTART    ; Load start address of program block
    ld  b, DMA_PROGRAM_RESTART_LEN          ; Load length of program block
    jr  DmaUpload

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------