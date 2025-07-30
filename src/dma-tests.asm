; -----------------------------------------------------------
; SECTION: Segments
; -----------------------------------------------------------
                seg     CODE_SEG, 4:$0000,$8000      ; Main code
                seg     DATA_SEG, 5:$0000,$4000      ; Data/buffers
                seg     TEST_SEG, 6:$0000,$4000      ; Unit test code/data (optional)

                seg     TEST_SEG
#include "unit-test.inc"

                seg     CODE_SEG
#include "dma.asm"

                seg     CODE_SEG
#include "dma-vars.asm"

; DMA-specific assertion macro
macro assert_dma_complete
    ; ...your assertion logic...
endm

TEST DMA_Test_Transfer
    ; Setup
    ;ld   a, $01
    ;out  (DMA_PORT), a

    ; Assert
    ;call WaitDMA
    ;call assert_dma_complete

    ret
ENDT

; Add more tests as needed
;TEST DMA_Test_Another
;    ...
;    ret
;ENDT

; Table of tests for this module
TestsTable:
    dw DMA_Test_Transfer
    ;dw DMA_Test_Another

NumTests: equ ($ - TestsTable) / 2