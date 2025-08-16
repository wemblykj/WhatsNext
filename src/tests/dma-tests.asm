    OPT     --zxnext    
    DEVICE  ZXSPECTRUMNEXT

    INCLUDE "dma-defs.inc"
    
; -----------------------------------------------------------
; SECTION: Main code (code under test)
; -----------------------------------------------------------
    ORG $9000
    INCLUDE "dma-vars.inc"

    ORG $8000                       ; Main code starting at $8000
    INCLUDE "dma-lib.asm"

; -----------------------------------------------------------
; SECTION: Test code
; -----------------------------------------------------------
    ORG $C000                       ; Test code starting at $C000

    ; Include test framework
    INCLUDE "unit-test.inc"

    ; Label the entry point for the test runner
    TestEntryPoint:
        call Start       ; Jump to the test framework's entry point
        rst 0x08         ; Return from the test
        ret

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

    ; -----------------------------------------------------------
    ; DMA_WR0 Macro Unit Tests
    ; -----------------------------------------------------------

    TEST DMA_WR0_AllParams
        ; Should emit base + 4 bytes
        wr0_all_start:
            DMA_WR0 0x01, 0x02, 0x03, 0x04
        wr0_all_end:
        ld hl, wr0_all_start
        ld de, wr0_all_expected
        ld bc, wr0_all_end-wr0_all_start
        call assert_mem_equal
        ret
    ENDT

    wr0_all_expected:
        db ((1<<1)|(1<<2)|(1<<3)|(1<<4))    ; base flags: all present
        db 0x01, 0x02, 0x03, 0x04

    TEST DMA_WR0_SomeParams
        ; Only PA_MSB and BL_MSB present
        wr0_some_start:
            DMA_WR0 -1, 0xAA, -1, 0xBB
        wr0_some_end:
        ld hl, wr0_some_start
        ld de, wr0_some_expected
        ld bc, wr0_some_end-wr0_some_start
        call assert_mem_equal
        ret
    ENDT

    wr0_some_expected:
        db ((1<<2)|(1<<4))    ; base flags: PA_MSB and BL_MSB
        db 0xAA, 0xBB

    TEST DMA_WR0_None    ; No parameters present
        wr0_none_start:
            DMA_WR0 -1, -1, -1, -1
        wr0_none_end:
        ld hl, wr0_none_start
        ld de, wr0_none_expected
        ld bc, wr0_none_end-wr0_none_start
        call assert_mem_equal
        ret
    ENDT

    wr0_none_expected:
        db 0x00    ; base flags: none present

    ; Add these to the test table:
    TestsTable:
        dw DMA_Test_Transfer
        dw DMA_WR0_AllParams
        dw DMA_WR0_SomeParams
        dw DMA_WR0_None

    NumTests: equ ($ - TestsTable) / 2

    ; ResultsTable holds the result status for each test:
    ;   0 = not run
    ;   1 = pass
    ;   2 = fail
    ;   3 = running
    ResultsTable:
        ds NumTests, 0    ; Reserve NumTests bytes,

    ; In your test runner, before running tests:
        ld hl, ResultsTable
        ld b, NumTests
    .clear_results:
        ld (hl), 0
        inc hl
        djnz .clear_results

    ; After each test, set result:
    ;   ld hl, ResultsTable
    ;   add hl, test_index
    ;   ld (hl), 1    ; 1 = pass, 2 = fail