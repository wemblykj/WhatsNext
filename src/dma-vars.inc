; -----------------------------------------------------------
; File:        dma-vars.inc
; Project:     WemblyKJ Next - DMA Routines
; Description: Working variables, buffers, and persistent data
;              used by DMA routines. Place in DATA segment.
; -----------------------------------------------------------

; -----------------------------------------------------------
; SECTION: DMA Global program block
; -----------------------------------------------------------
dma_program_block_transfer:
    DMA_WR6 DMA_COMMAND_DISABLE, -1                                           ; disable DMA
    DMA_WR0_BASE 1, 1, 1, 1, 1                          ; A-to-B transfer, Port A LSB/MSB, Block length LSB/MSB
dma_program_block_source:    dw 0                       ; WR0-Port A, Start address (source address)
dma_program_block_length:    dw 0                       ; WR0-Block length (length in bytes)
    DMA_WR1 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_4
    DMA_WR2 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_4
    DMA_WR4_BASE 1, 1, DMA_MODE_CONTINUOUS ;
dma_program_block_dest:      dw 0                       ; WR4-Destination address
    DMA_WR5 1, 0
    DMA_WR6 DMA_COMMAND_LOAD, -1
    DMA_WR6 DMA_COMMAND_ENABLE, -1
dma_program_block_end:
dmaProgramBlockLen equ dma_program_block_end-dma_program_block_transfer

; -----------------------------------------------------------
; SECTION: DMA Buffers
; -----------------------------------------------------------
;dma_buffer:     ds 256      ; Example DMA transfer buffer

; -----------------------------------------------------------
; SECTION: DMA State Variables
; -----------------------------------------------------------
;dma_status:     db 0        ; Example status byte
;dma_counter:    db 0        ; Example counter

; -----------------------------------------------------------
; SECTION: Temporary Variables
; -----------------------------------------------------------
;dma_temp:       db 0        ; Example temporary variable

; -----------------------------------------------------------
; Add more variables and buffers as needed below
; -----------------------------------------------------------
