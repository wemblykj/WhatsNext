; -----------------------------------------------------------
; dma-tests.asm
; Unit tests for DMA macros using DeZog unit testing framework
; -----------------------------------------------------------

    INCLUDE "dma-defs.inc"

; -----------------------------------------------------------
; Macro Test Data
; -----------------------------------------------------------

; Generate DMA command with no parameters
wrx_none_start:
    DMA_WRx %00000010, %01111100, %00000001

; Generate DMA command with no parameters
wrx_all_start:
    DMA_WRx %01111110, %01111100, %00000001

; Generate DMA command with no parameters
wr0_raw_none_start:
    DMA_WR0_RAW %00000000

    ; Generate DMA command with no parameters
wr0_raw_all_start:
    DMA_WR0_RAW %11111

    ; Generate DMA command with no parameters
wr0_base_none_start:
    DMA_WR0_BASE %0, %0, %0, %0, %0

    ; Generate DMA command with all parameters
wr0_base_all_start:
    DMA_WR0_BASE 1, 1, 1, 1, 1
    
    ; Generate DMA command with all parameters
wr0_base_dir_start:
    DMA_WR0_BASE 1, 0, 0, 0, 0
    
    ; Generate DMA command with all parameters
wr0_base_palsb_start:
    DMA_WR0_BASE 0, 1, 0, 0, 0
    
    ; Generate DMA command with all parameters
wr0_base_pamsb_start:
    DMA_WR0_BASE 0, 0, 1, 0, 0
    
    ; Generate DMA command with all parameters
wr0_base_bllsb_start:
    DMA_WR0_BASE 0, 0, 0, 1, 0
    
    ; Generate DMA command with all parameters
wr0_base_blmsb_start:
    DMA_WR0_BASE 0, 0, 0, 0, 1
    
    ; Generate DMA command with all parameters
wr0_all_start:
    DMA_WR0 0, 0x01, 0x02, 0x03, 0x04

    ; Generate DMA command with some parameters (-1 for unused)
wr0_some_start:
    DMA_WR0 1, -1, 0xAA, -1, 0xBB

; Generate DMA command with no parameters
wr0_none_start:
    DMA_WR0 0, -1, -1, -1, -1

; Generate DMA_WR1 with timing
wr1_timing_start:
    DMA_WR1 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_4
 
    ; Generate DMA_WR1 without timing
wr1_no_timing_start:
    DMA_WR1 DMA_SRC_IO, DMA_ADDRH_FIXED, -1
 
    ; Generate DMA_WR2 with timing and prescalar
wr2_timing_start:
    DMA_WR2 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_3, 2

    ; Generate DMA_WR2 with timing only
wr2_timing_only_start:
    DMA_WR2 DMA_SRC_IO, DMA_ADDRH_DEC, DMA_TIMING_2, -1

    ; Generate DMA_WR2 with prescalar only
wr2_prescalar_only_start:
    DMA_WR2 DMA_SRC_MEM, DMA_ADDRH_FIXED, -1, 3

    ; Generate DMA_WR2 without timing
wr2_no_timing_start:
    DMA_WR2 DMA_SRC_IO, DMA_ADDRH_FIXED, -1, -1
 
    ; Generate DMA_WR3 with enable=1
wr3_enable_start:
    DMA_WR3 1

    ; Generate DMA_WR3 with enable=0
wr3_disable_start:
    DMA_WR3 0

    ; Generate DMA_WR4 with all parameters
wr4_all_start:
    DMA_WR4 0x55, 0xAA, DMA_MODE_CONTINUOUS

    ; Generate DMA_WR4 with partial parameters
wr4_partial_start:
    DMA_WR4 -1, 0x33, DMA_MODE_BURST
        ; Generate DMA_WR4 with just mode
wr4_mode_only_start:
    DMA_WR4 -1, -1, DMA_MODE_CONTINUOUS

    ; Generate DMA_WR5 with both parameters
wr5_both_start:
    DMA_WR5 1, 1

    ; Generate DMA_WR5 with ready_config=1, stop_config=0
wr5_ready_only_start:
    DMA_WR5 1, 0

    ; Generate DMA_WR5 with ready_config=0, stop_config=1
wr5_stop_only_start:
    DMA_WR5 0, 1

    ; Generate DMA_WR6 with READMASK
wr6_readmask_start:
    DMA_WR6 DMA_COMMAND_READMASK, 0x55

    ; Generate DMA_WR6 with ENABLE command
wr6_enable_start:
    DMA_WR6 DMA_COMMAND_ENABLE, -1

    ; Generate DMA_WR6 with DISABLE command
wr6_disable_start:
    DMA_WR6 DMA_COMMAND_DISABLE, -1
    
    ; Generate DMA_WR6 with LOAD command
wr6_load_start:
    DMA_WR6 DMA_COMMAND_LOAD, -1
                                                               

; -----------------------------------------------------------
; Macro Unit Tests
; -----------------------------------------------------------

    MODULE TestSuite_Dma_Macros

UT_DMA_WRx_NoParams:
    ; Test that the base byte has the correct flags
    ; 0b00000001 = (0 | (0<<1) | (0<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wrx_none_start, %0'00000'01
 TC_END

UT_DMA_WRx_AllParams:
    ; Test that the base byte has the correct flags
    ; 0b01111101 = (1 | (1<<1) | (1<<2) | (1<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wrx_all_start, %0'11111'01
 TC_END

UT_DMA_WR0_RAW_NoParams:
    ; Test that the base byte has the correct flags
    ; 0b00000001 = (0 | (0<<1) | (0<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_raw_none_start, %0'00000'01
 TC_END

UT_DMA_WR0_RAW_AllParams:
    ; Test that the base byte has the correct flags
    ; 0b01111101 = (1 | (1<<1) | (1<<2) | (1<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_raw_all_start, %0'11111'01
 TC_END

UT_DMA_WR0_BASE_NoParams:
    ; Test that the base byte has the correct flags
    ; 0b00000001 = (0 | (0<<1) | (0<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_none_start, %0'00000'01
 TC_END

UT_DMA_WR0_BASE_AllParams:
    ; Test that the base byte has the correct flags
    ; 0b01111101 = (1 | (1<<1) | (1<<2) | (1<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_all_start, %0'11111'01
 TC_END

UT_DMA_WR0_BASE_Direction:
    ; Test that the base byte has the correct flags
    ; 0b00000101 = (1 | (0<<1) | (0<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_dir_start, %0'00001'01
 TC_END

UT_DMA_WR0_BASE_PortAddressLow:
    ; Test that the base byte has the correct flags
    ; 0b01010101 = (0 | (1<<1) | (0<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_palsb_start, %0'00010'01
 TC_END

UT_DMA_WR0_BASE_PortAddressHigh:
    ; Test that the base byte has the correct flags
    ; 0b01010101 = (0 | (0<<1) | (1<<2) | (0<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_pamsb_start, %0'00100'01
 TC_END

UT_DMA_WR0_BASE_BlockLengthLow:
    ; Test that the base byte has the correct flags
    ; 0b01010101 = (0 | (0<<1) | (0<<2) | (1<<3) | (0<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_bllsb_start, %0'01000'01
 TC_END

UT_DMA_WR0_BASE_BlockLengthHigh:
    ; Test that the base byte has the correct flags
    ; 0b01010101 = (0 | (0<<1) | (0<<2) | (0<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_base_blmsb_start, %0'10000'01
 TC_END

; Test DMA_WR0 with all parameters present
UT_DMA_WR0_AllParams:
    ; DMA_WR0 0, 0x01, 0x02, 0x03, 0x04

    ; Test that the base byte has the correct flags
    ; 0b01111001 = (0 | (1<<1) | (1<<2) | (1<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_all_start, %0'11110'01
    
    ; Test that PA_LSB was written correctly
    TEST_MEMORY_BYTE wr0_all_start+1, 0x01
    
    ; Test that PA_MSB was written correctly
    TEST_MEMORY_BYTE wr0_all_start+2, 0x02
    
    ; Test that BL_LSB was written correctly
    TEST_MEMORY_BYTE wr0_all_start+3, 0x03
    
    ; Test that BL_MSB was written correctly
    TEST_MEMORY_BYTE wr0_all_start+4, 0x04
    
 TC_END

; Test DMA_WR0 with only some parameters present (PA_MSB and BL_MSB)
UT_DMA_WR0_SomeParams:
    ; DMA_WR0 1, -1, 0xAA, -1, 0xBB

    ; Test that the base byte has the correct flags (bits 2 and 4 set)
    ; 0b01010101 = (1 | (0<<1) | (1<<2) | (0<<3) | (1<<4)) << 2 | 0x01
    TEST_MEMORY_BYTE wr0_some_start, %0'10'10'1'01
    
    ; Test that PA_MSB was written correctly
    TEST_MEMORY_BYTE wr0_some_start+1, 0xAA
    
    ; Test that BL_MSB was written correctly
    TEST_MEMORY_BYTE wr0_some_start+2, 0xBB
    
 TC_END

; Test DMA_WR0 with no parameters present
UT_DMA_WR0_None: 
    ; DMA_WR0 0, -1, -1, -1, -1

    ; Test that only the base byte is emitted with no flags set
    TEST_MEMORY_BYTE wr0_none_start, %0'00000'01
    
 TC_END

; -----------------------------------------------------------
; DMA_WR1 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR1 with timing parameter
UT_DMA_WR1_WithTiming:
    ; DMA_WR1 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_4

    ; Test that the base byte has the correct flags
    ; Base: (0 | 1<<1 | 1<<3) << 3 | 0x04
    TEST_MEMORY_BYTE wr1_timing_start, %0'1'01'0'100
    
    ; Test that timing byte was written correctly
    TEST_MEMORY_BYTE wr1_timing_start+1, DMA_TIMING_4
    
 TC_END

; Test DMA_WR1 without timing parameter
UT_DMA_WR1_NoTiming:
    ; DMA_WR1 DMA_SRC_IO, DMA_ADDRH_FIXED, -1

    ; Test that the base byte has the correct flags
    ; Base: (1 | 2<<1 | 0<<3) << 3 | 0x04
    TEST_MEMORY_BYTE wr1_no_timing_start, %0'0'10'1'100
    
 TC_END

; -----------------------------------------------------------
; DMA_WR2 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR2 with timing and prescalar
UT_DMA_WR2_WithTimingAndPrescalar:
    ; DMA_WR2 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_3, 2

    ; Test that the base byte has the correct flags
    ; Base: (0 | 1<<1 | 1<<3) << 3 | 0x00
    TEST_MEMORY_BYTE wr2_timing_start, %0'1'01'0'000
    
    ; Test that timing byte was written correctly with prescalar
    ; 0b01000001 = DMA_TIMING_3 | (2 << 5)
    TEST_MEMORY_BYTE wr2_timing_start+1, %0'10'000'01
    
 TC_END

; Test DMA_WR2 with just timing (no prescalar)
UT_DMA_WR2_WithTiming:
    ; DMA_WR2 DMA_SRC_IO, DMA_ADDRH_DEC, DMA_TIMING_2, -1

    ; Test that the base byte has the correct flags
    ; Base: (1 | 0<<1 | 1<<3) << 3 | 0x00
    TEST_MEMORY_BYTE wr2_timing_only_start, %0'1'00'1'000
    
    ; Test that timing byte was written correctly with no prescalar
    TEST_MEMORY_BYTE wr2_timing_only_start+1, DMA_TIMING_2
    
 TC_END

; Test DMA_WR2 with just prescalar (default timing)
UT_DMA_WR2_WithPrescalar:
    ; DMA_WR2 DMA_SRC_MEM, DMA_ADDRH_FIXED, -1, 3

    ; Test that the base byte has the correct flags
    ; Base: (0 | 2<<1 | 1<<3) << 3 | 0x00
    TEST_MEMORY_BYTE wr2_prescalar_only_start, %0'0'10'0'000
    
    ; Test that timing byte was written with default timing and specified prescalar
    ; 0b01100000 = 0 | (3 << 5)
    TEST_MEMORY_BYTE wr2_prescalar_only_start+1, %0'11'00000
    
 TC_END

; Test DMA_WR2 without timing or prescalar
UT_DMA_WR2_NoTimingNoPrescalar:
    ; DMA_WR2 DMA_SRC_IO, DMA_ADDRH_FIXED, -1, -1

    ; Test that the base byte has the correct flags
    ; Base: (1 | 2<<1 | 0<<3) << 3 | 0x00
    TEST_MEMORY_BYTE wr2_no_timing_start, %0'0'10'1'000
    
 TC_END

; -----------------------------------------------------------
; DMA_WR3 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR3 with enable=1
UT_DMA_WR3_Enable:
    ; DMA_WR3 1

    ; Test that the byte has the correct flags
    ; 0b11000000 = (1 << 6) | 0x80
    TEST_MEMORY_BYTE wr3_enable_start, %1'1'000000
    
 TC_END

; Test DMA_WR3 with enable=0
UT_DMA_WR3_Disable:  
    ; DMA_WR3 0

    ; Test that the byte has the correct flags
    ; 0b10000000 = (0 << 6) | 0x80
    TEST_MEMORY_BYTE wr3_disable_start, %1'0'000000
    
 TC_END

; -----------------------------------------------------------
; DMA_WR4 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR4 with all parameters
UT_DMA_WR4_AllParams:
    ; DMA_WR4 0x55, 0xAA, DMA_MODE_CONTINUOUS

    ; Test that the base byte has the correct flags
    ; Base: ((1 | 1<<1 | MODE_CONTINUOUS<<3) << 2) | 0x81
    TEST_MEMORY_BYTE wr4_all_start, %1'01'0'1'1'01
    
    ; Test that PA_LSB was written correctly
    TEST_MEMORY_BYTE wr4_all_start+1, 0x55
    
    ; Test that PA_MSB was written correctly
    TEST_MEMORY_BYTE wr4_all_start+2, 0xAA
    
 TC_END

; Test DMA_WR4 with partial parameters
UT_DMA_WR4_PartialParams:
    ; DMA_WR4 -1, 0x33, DMA_MODE_BURST

    ; Test that the base byte has the correct flags
    ; Base: ((0 | 1<<1 | MODE_BURST<<3) << 2) | 0x81
    TEST_MEMORY_BYTE wr4_partial_start, %1'10'0'1'0'01
    
    ; Test that PA_MSB was written correctly
    TEST_MEMORY_BYTE wr4_partial_start+1, 0x33
    
 TC_END

; Test DMA_WR4 with just mode
UT_DMA_WR4_JustMode:
    ; DMA_WR4 -1, -1, DMA_MODE_CONTINUOUS

    ; Test that the base byte has the correct flags
    ; Base: ((0 | 0<<1 | MODE_CONTINUOUS<<3) << 2) | 0x81
    TEST_MEMORY_BYTE wr4_mode_only_start, %1'01'0'0'0'01
    
 TC_END

; -----------------------------------------------------------
; DMA_WR5 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR5 with both parameters
UT_DMA_WR5_BothParams:
    ; Test that the byte has the correct flags
    ; 0b10110010 = (1 | 1<<1) << 4 | 0x82
    TEST_MEMORY_BYTE wr5_both_start, %10'11'0010
    
 TC_END

; Test DMA_WR5 with ready only
UT_DMA_WR5_ReadyOnly: 
    ; Test that the byte has the correct flags
    ; 0b10010010 = (1 | 0<<1) << 4 | 0x82
    TEST_MEMORY_BYTE wr5_ready_only_start, %10'01'0010
    
 TC_END

; Test DMA_WR5 with stop only
UT_DMA_WR5_StopOnly:
    ; Test that the byte has the correct flags
    ; 0b10100010 = (0 | 1<<1) << 4 | 0x82
    TEST_MEMORY_BYTE wr5_stop_only_start, %10'10'0010
    
 TC_END

; -----------------------------------------------------------
; DMA_WR6 Macro Unit Tests
; -----------------------------------------------------------

; Test DMA_WR6 with READMASK command
UT_DMA_WR6_ReadMask:
    ; DMA_WR6 DMA_COMMAND_READMASK, 0x55

    ; Test that the base byte has the correct flags
    ; Base: (DMA_COMMAND_READMASK << 2) | 0x83
    TEST_MEMORY_BYTE wr6_readmask_start, %1'01110'11
    
    ; Test that mask byte was written correctly
    TEST_MEMORY_BYTE wr6_readmask_start+1, %11010101
    
 TC_END

; Test DMA_WR6 with ENABLE command
UT_DMA_WR6_Enable:
    ; Test that the base byte has the correct flags
    ; Base: (DMA_COMMAND_ENABLE << 2) | 0x83
    TEST_MEMORY_BYTE wr6_enable_start, %1'00001'11
    
 TC_END

; Test DMA_WR6 with DISABLE command
UT_DMA_WR6_Disable:
    ; Test that the base byte has the correct flags
    ; Base: (DMA_COMMAND_DISABLE << 2) | 0x83
    TEST_MEMORY_BYTE wr6_disable_start, %1'00000'11
    
 TC_END

; Test DMA_WR6 with LOAD command
UT_DMA_WR6_Load:
    ; Test that the base byte has the correct flags
    ; Base: (DMA_COMMAND_LOAD << 2) | 0x83
    TEST_MEMORY_BYTE wr6_load_start, %1'10011'11
    
 TC_END

    ENDMODULE