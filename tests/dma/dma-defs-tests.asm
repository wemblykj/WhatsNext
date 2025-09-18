; -----------------------------------------------------------
; File:        dma-defs-tests.asm
; Project:     WhatsNext - DMA Routines
; Description: Unit tests for DMA macro definitions using the
;              DeZog unit testing framework. Verifies correct
;              byte emission for all DMA macros as per the
;              ZX Spectrum Next documentation:
;              https://wiki.specnext.dev/DMA
; Author:      Paul Wightmore. (c) 2025
; License:     MIT License
; -----------------------------------------------------------

    INCLUDE "dma-defs.inc"
    INCLUDE "dma-macros.inc"

; -----------------------------------------------------------
; Macro Test Data
; -----------------------------------------------------------
; Each block below generates bytes using a DMA macro with
; specific parameters. These are referenced in the test cases.

WRX_NONE_START:         DMA_WRx %00000010, %01111100, %00000001
WRX_ALL_START:          DMA_WRx %01111110, %01111100, %00000001

WR0_RAW_NONE_START:     DMA_WR0_RAW %00000000
WR0_RAW_ALL_START:      DMA_WR0_RAW %11111

WR0_BASE_NONE_START:    DMA_WR0_BASE %0, %0, %0, %0, %0
WR0_BASE_ALL_START:     DMA_WR0_BASE 1, 1, 1, 1, 1
WR0_BASE_DIR_START:     DMA_WR0_BASE 1, 0, 0, 0, 0
WR0_BASE_PALSB_START:   DMA_WR0_BASE 0, 1, 0, 0, 0
WR0_BASE_PAMSB_START:   DMA_WR0_BASE 0, 0, 1, 0, 0
WR0_BASE_BLLSB_START:   DMA_WR0_BASE 0, 0, 0, 1, 0
WR0_BASE_BLMSB_START:   DMA_WR0_BASE 0, 0, 0, 0, 1

WR0_ALL_START:          DMA_WR0 0, 0x01, 0x02, 0x03, 0x04
WR0_SOME_START:         DMA_WR0 1, -1, 0xAA, -1, 0xBB
WR0_NONE_START:         DMA_WR0 0, -1, -1, -1, -1

WR1_TIMING_START:       DMA_WR1 DMA_PORTTYPE_MEM, DMA_ADDRH_INC, DMA_TIMING_4
WR1_NO_TIMING_START:    DMA_WR1 DMA_PORTTYPE_IO, DMA_ADDRH_FIXED, -1

WR2_TIMING_START:       DMA_WR2 DMA_PORTTYPE_MEM, DMA_ADDRH_INC, DMA_TIMING_3, 2
WR2_TIMING_ONLY_START:  DMA_WR2 DMA_PORTTYPE_IO, DMA_ADDRH_DEC, DMA_TIMING_2, -1
WR2_PRESCALAR_ONLY_START: DMA_WR2 DMA_PORTTYPE_MEM, DMA_ADDRH_FIXED, -1, 3
WR2_NO_TIMING_START:    DMA_WR2 DMA_PORTTYPE_IO, DMA_ADDRH_FIXED, -1, -1

WR3_ENABLE_START:       DMA_WR3 1
WR3_DISABLE_START:      DMA_WR3 0

WR4_ALL_START:          DMA_WR4 0x55, 0xAA, DMA_MODE_CONTINUOUS
WR4_PARTIAL_START:      DMA_WR4 -1, 0x33, DMA_MODE_BURST
WR4_MODE_ONLY_START:    DMA_WR4 -1, -1, DMA_MODE_CONTINUOUS

WR5_BOTH_START:         DMA_WR5 1, 1
WR5_READY_ONLY_START:   DMA_WR5 1, 0
WR5_STOP_ONLY_START:    DMA_WR5 0, 1

WR6_READMASK_START:     DMA_WR6 DMA_COMMAND_READMASK, 0x55
WR6_ENABLE_START:       DMA_WR6 DMA_COMMAND_ENABLE, -1
WR6_DISABLE_START:      DMA_WR6 DMA_COMMAND_DISABLE, -1
WR6_LOAD_START:         DMA_WR6 DMA_COMMAND_LOAD, -1

; -----------------------------------------------------------
; DMA Macro Unit Tests (DeZog)
; -----------------------------------------------------------

    MODULE TESTSUITE_DMA_MACROS

; -----------------------------------------------------------
; DMA_WRx Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WRX_NOPARAMS:
    ; Should emit base byte with no flags set
    TEST_MEMORY_BYTE WRX_NONE_START, %00000001
  TC_END

UT_DMA_WRX_ALLPARAMS:
    ; Should emit base byte with all flags set
    TEST_MEMORY_BYTE WRX_ALL_START, %1111101
  TC_END

; -----------------------------------------------------------
; DMA_WR0_RAW Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR0_RAW_NOPARAMS:
    TEST_MEMORY_BYTE WR0_RAW_NONE_START, %00000001
  TC_END

UT_DMA_WR0_RAW_ALLPARAMS:
    TEST_MEMORY_BYTE WR0_RAW_ALL_START, %1111101
  TC_END

; -----------------------------------------------------------
; DMA_WR0_BASE Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR0_BASE_NOPARAMS:
    TEST_MEMORY_BYTE WR0_BASE_NONE_START, %00000001
  TC_END

UT_DMA_WR0_BASE_ALLPARAMS:
    TEST_MEMORY_BYTE WR0_BASE_ALL_START, %1111101
  TC_END

UT_DMA_WR0_BASE_DIRECTION:
    TEST_MEMORY_BYTE WR0_BASE_DIR_START, %0000101
  TC_END

UT_DMA_WR0_BASE_PORTADDRESSLOW:
    TEST_MEMORY_BYTE WR0_BASE_PALSB_START, %0001001
  TC_END

UT_DMA_WR0_BASE_PORTADDRESSHIGH:
    TEST_MEMORY_BYTE WR0_BASE_PAMSB_START, %0010001
  TC_END

UT_DMA_WR0_BASE_BLOCKLENGTHLOW:
    TEST_MEMORY_BYTE WR0_BASE_BLLSB_START, %0100001
  TC_END

UT_DMA_WR0_BASE_BLOCKLENGTHHIGH:
    TEST_MEMORY_BYTE WR0_BASE_BLMSB_START, %1000001
  TC_END

; -----------------------------------------------------------
; DMA_WR0 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR0_ALLPARAMS:
    ; DMA_WR0 0, 0x01, 0x02, 0x03, 0x04
    TEST_MEMORY_BYTE WR0_ALL_START, %1111001
    TEST_MEMORY_BYTE WR0_ALL_START+1, 0x01
    TEST_MEMORY_BYTE WR0_ALL_START+2, 0x02
    TEST_MEMORY_BYTE WR0_ALL_START+3, 0x03
    TEST_MEMORY_BYTE WR0_ALL_START+4, 0x04
  TC_END

UT_DMA_WR0_SOMEPARAMS:
    ; DMA_WR0 1, -1, 0xAA, -1, 0xBB
    TEST_MEMORY_BYTE WR0_SOME_START, %1010101
    TEST_MEMORY_BYTE WR0_SOME_START+1, 0xAA
    TEST_MEMORY_BYTE WR0_SOME_START+2, 0xBB
  TC_END

UT_DMA_WR0_NONE:
    ; DMA_WR0 0, -1, -1, -1, -1
    TEST_MEMORY_BYTE WR0_NONE_START, %00000001
  TC_END

; -----------------------------------------------------------
; DMA_WR1 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR1_WITHTIMING:
    TEST_MEMORY_BYTE WR1_TIMING_START, %01010100
    TEST_MEMORY_BYTE WR1_TIMING_START+1, DMA_TIMING_4
  TC_END

UT_DMA_WR1_NOTIMING:
    TEST_MEMORY_BYTE WR1_NO_TIMING_START, %00101100
  TC_END

; -----------------------------------------------------------
; DMA_WR2 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR2_WITHTIMINGANDPRESCALAR:
    TEST_MEMORY_BYTE WR2_TIMING_START, %01010000
    TEST_MEMORY_BYTE WR2_TIMING_START+1, %01000001
  TC_END

UT_DMA_WR2_WITHTIMING:
    TEST_MEMORY_BYTE WR2_TIMING_ONLY_START, %01001000
    TEST_MEMORY_BYTE WR2_TIMING_ONLY_START+1, DMA_TIMING_2
  TC_END

UT_DMA_WR2_WITHPRESCALAR:
    TEST_MEMORY_BYTE WR2_PRESCALAR_ONLY_START, %00100000
    TEST_MEMORY_BYTE WR2_PRESCALAR_ONLY_START+1, %01100000
  TC_END

UT_DMA_WR2_NOTIMINGNOPRESCALAR:
    TEST_MEMORY_BYTE WR2_NO_TIMING_START, %00101000
  TC_END

; -----------------------------------------------------------
; DMA_WR3 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR3_ENABLE:
    TEST_MEMORY_BYTE WR3_ENABLE_START, %11000000
  TC_END

UT_DMA_WR3_DISABLE:
    TEST_MEMORY_BYTE WR3_DISABLE_START, %10000000
  TC_END

; -----------------------------------------------------------
; DMA_WR4 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR4_ALLPARAMS:
    TEST_MEMORY_BYTE WR4_ALL_START, %10101101
    TEST_MEMORY_BYTE WR4_ALL_START+1, 0x55
    TEST_MEMORY_BYTE WR4_ALL_START+2, 0xAA
  TC_END

UT_DMA_WR4_PARTIALPARAMS:
    TEST_MEMORY_BYTE WR4_PARTIAL_START, %11001001
    TEST_MEMORY_BYTE WR4_PARTIAL_START+1, 0x33
  TC_END

UT_DMA_WR4_JUSTMODE:
    TEST_MEMORY_BYTE WR4_MODE_ONLY_START, %10100001
  TC_END

; -----------------------------------------------------------
; DMA_WR5 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR5_BOTHPARAMS:
    TEST_MEMORY_BYTE WR5_BOTH_START, %10110010
  TC_END

UT_DMA_WR5_READYONLY:
    TEST_MEMORY_BYTE WR5_READY_ONLY_START, %10010010
  TC_END

UT_DMA_WR5_STOPONLY:
    TEST_MEMORY_BYTE WR5_STOP_ONLY_START, %10100010
  TC_END

; -----------------------------------------------------------
; DMA_WR6 Macro Unit Tests
; -----------------------------------------------------------
UT_DMA_WR6_READMASK:
    TEST_MEMORY_BYTE WR6_READMASK_START, %10111011
    TEST_MEMORY_BYTE WR6_READMASK_START+1, %11010101
  TC_END

UT_DMA_WR6_ENABLE:
    TEST_MEMORY_BYTE WR6_ENABLE_START, %10000111
  TC_END

UT_DMA_WR6_DISABLE:
    TEST_MEMORY_BYTE WR6_DISABLE_START, %10000011
  TC_END

UT_DMA_WR6_LOAD:
    TEST_MEMORY_BYTE WR6_LOAD_START, %11001111
  TC_END

    ENDMODULE