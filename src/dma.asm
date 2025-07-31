; -----------------------------------------------------------
; File:        dma.asm
; Project:     WemblyKJ Next
; Author:      [Your Name]
; Date:        [YYYY-MM-DD]
; Description: Z80 sjasmplus compatible source file for DMA

; This file uses sjasmplus SECTIONS to separate code and data.
; The ORIGIN of each section should be defined in the top-level assembly file.
; Example (in your top-level .asm file):
;   SECTION code_user: ORG $8000
;   SECTION data_user: ORG $C000

;              (Direct Memory Access) routines and definitions.
; -----------------------------------------------------------

; -----------------------------------------------------------
; SECTION: Includes and Equates
; -----------------------------------------------------------
;#include "hardware.inc"      ; Example include
;#include "macros.inc"        ; Example include

;    INCLUDE "dma.inc"

; -----------------------------------------------------------
; SECTION: Library Functions (Subroutines)
; -----------------------------------------------------------
;dma_init:
;    ; Initialize DMA controller
;    ret
;

; dma_block_transfer
; DMA block of memory from one location to another
; hl   = source address
; de   = address of destination
; bc   = length of data
dma_block_transfer:
    ld  (dma_program_block_source), hl    ;  update source address in program block
    ld  (dma_program_block_length), bc    ;  update block length in program block
    ld  (dma_program_block_dest), de      ;  update destination address in program block
    ld  hl, dma_program_block_transfer    ;  load start of program block code
    ld  b, dmaProgramBlockLen             ;  load length of program block code
    ld  c, DMA_PORT_NEXT                  ;  set DMA data port
    otir                                  ;  output program block code to DMA data port
    ret

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------