; -----------------------------------------------------------
; File:        dma-macros.inc
; Project:     WhatsNext - DMA Routines
; Description: MACROs for constructing ZX Spectrum Next DMA
;              controller register commands and programs.
;              See: https://wiki.specnext.dev/DMA
; Author:      Paul Wightmore. (c) 2024
; License:     MIT License
; -----------------------------------------------------------

; Requires: INCLUDE "dma-defs.inc" before including this file

; -----------------------------------------------------------
; DMA MACRO DEFINITIONS
; These macros simplify the construction of DMA register
; values and programs for the ZX Spectrum Next DMA controller.
; Each macro corresponds to a specific WRx register or
; operation as described in the official documentation.
; -----------------------------------------------------------

    ; -------------------------------------------------------
    ; Generic macro for writing a value to a DMA register
    ; param: value to write (shifted as needed)
    ; mask:  bitmask for the register
    ; static: static bits for the register
    ; -------------------------------------------------------
    MACRO DMA_WRx param, mask, static
        db (param & mask) | static
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 0 GROUP: Port A and Block Length
; WR0 controls transfer direction, Port A address, and block length.
; -----------------------------------------------------------
    MACRO DMA_WR0_RAW param
        DMA_WRx (param << DMA_WR0_LSB), DMA_WR0_MASK, DMA_WR0_STATIC
    ENDM

    MACRO DMA_WR0_BASE td, has_pa_lsb, has_pa_msb, has_bl_lsb, has_bl_msb
        ; td: transfer direction (0=read, 1=write)
        ; has_*: set to 1 if the corresponding value will follow
        DMA_WR0_RAW (td | (has_pa_lsb << 1) | (has_pa_msb << 2) | (has_bl_lsb << 3) | (has_bl_msb << 4))
    ENDM

    MACRO DMA_WR0 td, pa_lsb, pa_msb, bl_lsb, bl_msb
        ; Emits WR0 base and any present address/length bytes
        DMA_WR0_BASE td, (pa_lsb != -1)&1, (pa_msb != -1)&1, (bl_lsb != -1)&1, (bl_msb != -1)&1
        if pa_lsb != -1
            db pa_lsb
        endif
        if pa_msb != -1
            db pa_msb
        endif
        if bl_lsb != -1
            db bl_lsb
        endif
        if bl_msb != -1
            db bl_msb
        endif
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 1 GROUP: Port A configuration
; -----------------------------------------------------------
    MACRO DMA_WR1_RAW param
        DMA_WRx (param << DMA_WR1_LSB), DMA_WR1_MASK, DMA_WR1_STATIC
    ENDM

    MACRO DMA_WR1_BASE port_type, addrh, has_timing
        ; port_type: DMA_PORT_ADDR or DMA_PORT_IO
        ; addrh: DMA_ADDRH_DEC/INC/FIXED
        ; has_timing: 1 if timing byte follows
        DMA_WR1_RAW (port_type | (addrh << 1) | (has_timing << 3))
    ENDM

    MACRO DMA_WR1_TIMING timing
        DMA_WRx timing, DMA_WR1_TIMING_MASK, DMA_WR1_TIMING_STATIC
    ENDM

    MACRO DMA_WR1 port_type, addrh, timing
        ; Emits WR1 base and optional timing byte
        DMA_WR1_BASE port_type, addrh, (timing != -1)&1
        if timing != -1
            DMA_WR1_TIMING timing
        endif
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 2 GROUP: Port B configuration
; -----------------------------------------------------------
    MACRO DMA_WR2_RAW param
        DMA_WRx (param << DMA_WR2_LSB), DMA_WR2_MASK, DMA_WR2_STATIC
    ENDM

    MACRO DMA_WR2_BASE port_type, addrh, has_timing
        DMA_WR2_RAW (port_type | (addrh << 1) | (has_timing << 3))
    ENDM

    MACRO DMA_WR2_TIMING timing, prescalar
        DMA_WRx (timing | (prescalar << 5)), DMA_WR2_TIMING_MASK, DMA_WR2_TIMING_STATIC
    ENDM

    MACRO DMA_WR2 port_type, addrh, timing, prescalar
        ; Emits WR2 base and optional timing/prescalar byte
        DMA_WR2_BASE port_type, addrh, (timing != -1)&1
        if timing != -1 and prescalar != -1
            DMA_WR2_TIMING timing, prescalar
        elseif timing != -1
            DMA_WR2_TIMING timing, 0
        elseif prescalar != -1
            DMA_WR2_TIMING 0, prescalar
        endif
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 3 GROUP: Miscellaneous control
; -----------------------------------------------------------
    MACRO DMA_WR3_RAW param
        DMA_WRx (param << DMA_WR3_LSB), DMA_WR3_MASK, DMA_WR3_STATIC
    ENDM

    MACRO DMA_WR3 enable
        ; enable: 1 to enable, 0 to disable
        DMA_WR3_RAW enable
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 4 GROUP: Port B and mode
; -----------------------------------------------------------
    MACRO DMA_WR4_RAW param
        DMA_WRx (param << DMA_WR4_LSB), DMA_WR4_MASK, DMA_WR4_STATIC
    ENDM

    MACRO DMA_WR4_BASE has_pa_lsb, has_pa_msb, mode
        DMA_WR4_RAW (has_pa_lsb | (has_pa_msb << 1) | (mode << 3))
    ENDM

    MACRO DMA_WR4 pa_lsb, pa_msb, mode
        ; Emits WR4 base and any present address bytes
        DMA_WR4_BASE (pa_lsb != -1)&1, (pa_msb != -1)&1, mode
        if pa_lsb != -1
            db pa_lsb
        endif
        if pa_msb != -1
            db pa_msb
        endif
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 5 GROUP: Ready/Stop configuration
; -----------------------------------------------------------
    MACRO DMA_WR5_RAW param
        DMA_WRx (param << DMA_WR5_LSB), DMA_WR5_MASK, DMA_WR5_STATIC
    ENDM

    MACRO DMA_WR5 ready_config, stop_config
        ; ready_config: 1 to enable ready, 0 to disable
        ; stop_config: 1 to enable stop, 0 to disable
        DMA_WR5_RAW (ready_config | (stop_config << 1))
    ENDM

; -----------------------------------------------------------
; WRITE REGISTER 6 GROUP: DMA command and mask
; -----------------------------------------------------------
    MACRO DMA_WR6_RAW param
        DMA_WRx (param << DMA_WR6_LSB), DMA_WR6_MASK, DMA_WR6_STATIC
    ENDM

    MACRO DMA_WR6_BASE command
        DMA_WR6_RAW command
    ENDM

    MACRO DMA_WR6_READMASK mask
        DMA_WRx mask, DMA_WR6_READMASK_MASK, DMA_WR6_READMASK_STATIC
    ENDM

    MACRO DMA_WR6 command, optional_param
        ; Emits WR6 base and, if command is READMASK, the mask byte
        DMA_WR6_BASE command
        if command == %01110
            DMA_WR6_READMASK optional_param
        endif
    ENDM

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------