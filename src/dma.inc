; -----------------------------------------------------------
; File:        dma.inc
; Project:     WemblyKJ Next - DMA Routines
; Description: Macros and equates for constructing DMA controller
;              register commands and programs. Use these macros
;              to build and emit register values for all WRx registers.
;              Internal bit masks and shifts are handled automatically.
; -----------------------------------------------------------

; -----------------------------------------------------------
; SECTION: DMA PORT AND MODE CONSTANTS
; -----------------------------------------------------------

DMA_PORT_MB02 equ 0x0B ; Data port for DMA operations
DMA_PORT_DATAGEAR equ 0x6B ; Data port for DMA operations

DMA_PORT_NEXT equ DMA_PORT_DATAGEAR

DMA_SRC_MEM     equ %00    ; Port is memory
DMA_SRC_IO      equ %01    ; Port is I/O

DMA_ADDRH_DEC   equ %00    ; Address decrements
DMA_ADDRH_INC   equ %01    ; Address increments
DMA_ADDRH_FIXED equ %10    ; Address is fixed

DMA_TIMING_4    equ %00    ; Timing 4 cycles
DMA_TIMING_3    equ %01    ; Timing 3 cycles
DMA_TIMING_2    equ %10    ; Timing 2 cycles

DMA_MODE_CONTINUOUS equ %01 ; Continuous mode
DMA_MODE_BURST      equ %10 ; Burst mode

DMA_COMMAND_ENABLE      equ %00001 ; Enable command
DMA_COMMAND_DISABLE     equ %00000 ; Disable command
DMA_COMMAND_READMASK    equ %01110 ; Read mask command
DMA_COMMAND_LOAD        equ %10011 ; Load command
DMA_COMMAND_CONTINUE    equ %10100 ; Continue command

; -----------------------------------------------------------
; SECTION: INTERNAL BIT MASKS AND SHIFTS (DO NOT USE DIRECTLY)
; -----------------------------------------------------------
DMA_WR0_MASK    equ %01111100
DMA_WR0_STATIC  equ %00000001
DMA_WR0_LSB     equ 2

DMA_WR1_MASK    equ %01111000
DMA_WR1_STATIC  equ %00000100
DMA_WR1_LSB     equ 3
DMA_WR1_TIMING_MASK    equ %00000011
DMA_WR1_TIMING_STATIC  equ %00000000
DMA_WR1_TIMING_LSB     equ 0

DMA_WR2_MASK    equ %01111000
DMA_WR2_STATIC  equ %00000000
DMA_WR2_LSB     equ 3
DMA_WR2_TIMING_MASK    equ %11100011
DMA_WR2_TIMING_STATIC  equ %00000000
DMA_WR2_TIMING_LSB     equ 0

DMA_WR3_MASK    equ %01000000
DMA_WR3_STATIC  equ %10000000
DMA_WR3_LSB     equ 6

DMA_WR4_MASK    equ %01111100
DMA_WR4_STATIC  equ %10000001
DMA_WR4_LSB     equ 2

DMA_WR5_MASK    equ %00110000
DMA_WR5_LSB     equ 4
DMA_WR5_STATIC  equ %10000010

DMA_WR6_MASK    equ %01111100
DMA_WR6_STATIC  equ %10000011
DMA_WR6_LSB     equ 2

DMA_WR6_READMASK_MASK   equ %01111111
DMA_WR6_READMASK_STATIC equ %10000000

; -----------------------------------------------------------
; SECTION: GENERIC MACRO FOR REGISTER CONSTRUCTION (INTERNAL)
; -----------------------------------------------------------
; Usage: DMA_WRx param, mask, static
; Applies a mask (AND) and then ORs with static bits.
macro DMA_WRx param, mask, static
    db (param & mask) | static
endm

; -----------------------------------------------------------
; SECTION: PUBLIC MACROS FOR DMA REGISTER COMMANDS
; -----------------------------------------------------------


; Advanced: Use a pre-assembled param value for WR0
macro DMA_WR0_RAW param
    DMA_WRx (param << DMA_WR0_LSB), DMA_WR0_MASK, DMA_WR0_STATIC
endm

; --- WR0: Direction, operation and port A configuration (base flags only) ---
; Usage: DMA_WR0_BASE has_pa_lsb, has_pa_msb, has_bl_lsb, has_bl_msb
; Each parameter is 0 (not present) or 1 (present)
macro DMA_WR0_BASE has_pa_lsb, has_pa_msb, has_bl_lsb, has_bl_msb
    local flags
    flags = (has_pa_lsb << 1) | (has_pa_msb << 2) | (has_bl_lsb << 3) | (has_bl_msb << 4)
    DMA_WR0_RAW flags
endm

; --- WR0: Write base register and optional parameter bytes ---
; Usage: DMA_WR0 pa_lsb, pa_msb, bl_lsb, bl_msb
; Each parameter: -1 = not present, otherwise value to emit as extra byte
macro DMA_WR0 pa_lsb, pa_msb, bl_lsb, bl_msb
    local flags
    flags = ((pa_lsb != -1) << 1) | ((pa_msb != -1) << 2) | ((bl_lsb != -1) << 3) | ((bl_msb != -1) << 4)
    DMA_WR0_RAW flags
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
endm

macro DMA_WR1_RAW param
    DMA_WRx (param << DMA_WR1_LSB), DMA_WR1_MASK, DMA_WR1_STATIC
endm

; --- WR1: Port A configuration (base flags only) ---
; Usage: DMA_WR1_BASE src, addrh, has_timing
;  src        = Source select (DMA_SRC_MEM or DMA_SRC_IO)
;  addrh      = Address mode (DMA_ADDRH_DEC/INC/FIXED)
;  has_timing = 0 (no timing byte) or 1 (timing byte present)
macro DMA_WR1_BASE src, addrh, has_timing
    local param
    param = src | (addrh << 1) | (has_timing << 3)
    DMA_WR1_RAW param
endm

; --- WR1: Port A variable timing ---
; Usage: DMA_WR1_TIMING timing
macro DMA_WR1_TIMING timing
    local param
    param = timing
    DMA_WRx param, DMA_WR1_TIMING_MASK, DMA_WR1_TIMING_STATIC
endm

; --- WR1: Write base register and optional timing byte ---
; Usage: DMA_WR1 src, addrh, timing
;  src     = DMA_SRC_MEM or DMA_SRC_IO
;  addrh   = DMA_ADDRH_DEC/INC/FIXED
;  timing  = -1 (no timing byte) or timing value
macro DMA_WR1 src, addrh, timing
    local param
    param = src | (addrh << 1) | ((timing != -1) << 3)
    DMA_WR1_RAW param
    if timing != -1
        DMA_WR1_TIMING timing
    endif
endm

macro DMA_WR2_RAW param
    DMA_WRx (param << DMA_WR2_LSB), DMA_WR2_MASK, DMA_WR2_STATIC
endm

; --- WR2: Port B configuration (base flags only) ---
; Usage: DMA_WR2_BASE src, addrh, has_timing
;  src        = Source select (DMA_SRC_MEM or DMA_SRC_IO)
;  addrh      = Address mode (DMA_ADDRH_DEC/INC/FIXED)
;  has_timing = 0 (no timing byte) or 1 (timing byte present)
macro DMA_WR2_BASE src, addrh, has_timing
    local param
    param = src | (addrh << 1) | (has_timing << 3)
    DMA_WR2_RAW param
endm

; --- WR2: Port B variable timing ---
; Usage: DMA_WR2_TIMING timing, prescaler
macro DMA_WR2_TIMING timing, prescaler
    local param
    param = timing | (prescaler << 5)
    DMA_WRx param, DMA_WR2_TIMING_MASK, DMA_WR2_TIMING_STATIC
endm
; --- WR2: Write base register and optional timing byte ---
; Usage: DMA_WR2 src, addrh, timing
;  src     = DMA_SRC_MEM or DMA_SRC_IO
;  addrh   = DMA_ADDRH_DEC/INC/FIXED
;  timing  = -1 (no timing byte) or timing value
macro DMA_WR2 src, addrh, timing
    local param
    param = src | (addrh << 1) | ((timing != -1) << 3)
    DMA_WR2_RAW param
    if timing != -1
        DMA_WR2_TIMING timing, 0
    endif
endm

macro DMA_WR3_RAW param
    DMA_WRx (param << DMA_WR3_LSB), DMA_WR3_MASK, DMA_WR3_STATIC
endm

; --- WR3: Activation ---
; Usage: DMA_WR3 enable
macro DMA_WR3 enable
    local param
    param = enable << 6
    DMA_WR3_RAW param
endm

macro DMA_WR4_RAW param
    DMA_WRx (param << DMA_WR4_LSB), DMA_WR4_MASK, DMA_WR4_STATIC
endm

; --- WR4: Port B, timing and interrupt configuration ---
; Usage: DMA_WR4 pa_lsb, pa_msb, mode
macro DMA_WR4 pa_lsb, pa_msb, mode
    local param
    param = (pa_lsb << 2) | (pa_msb << 3) | (mode << 5)
    DMA_WR4_RAW param
endm

macro DMA_WR5_RAW param
    DMA_WRx (param << DMA_WR5_LSB), DMA_WR5_MASK, DMA_WR5_STATIC
endm

; --- WR5: Ready and stop configuration ---
; Usage: DMA_WR5 ready_config, stop_config
macro DMA_WR5 ready_config, stop_config
    local param
    param = (ready_config << 4) | (stop_config << 5)
    DMA_WR5_RAW param
endm

macro DMA_WR6_RAW param
    DMA_WRx (param << DMA_WR6_LSB), DMA_WR6_MASK, DMA_WR6_STATIC
endm

; --- WR6: Command register (base only) ---
; Usage: DMA_WR6_BASE command
macro DMA_WR6_BASE command
    local param
    param = (command << 2)
    DMA_WR6_RAW param
endm

; --- WR6: Read mask ---
; Usage: DMA_WR6_READMASK mask
macro DMA_WR6_READMASK mask
    DMA_WRx mask, DMA_WR6_READMASK_MASK, DMA_WR6_READMASK_STATIC
endm

; --- WR6: Command register with optional parameter ---
; Usage: DMA_WR6 command, [optional_param]
; If command = %01110 (DMA_COMMAND_READMASK), emit extra byte using DMA_WR6_READMASK
macro DMA_WR6 command, optional_param
    DMA_WR6_BASE command
    if command == %01110
        DMA_WR6_READMASK optional_param
    endif
endm

; -----------------------------------------------------------
; SECTION: EXAMPLES
; -----------------------------------------------------------
; Example: Construct a DMA program block
; dmaBlockCode:
;     DMA_WR6 DMA_COMMAND_DISABLE           ; disable DMA
;     DMA_WR0 0x00, 0x80, 0x00, -1         ; WR0: PA_LSB=$00, PA_MSB=$80, BL_LSB=$00, BL_MSB not present
; dmaBlockSource:    dw 0                  ; WR0-Port A, Start address (source address)
; dmaBlockLength:    dw 0                  ; WR0-Block length (length in bytes)
;     DMA_WR1 DMA_SRC_MEM, DMA_ADDRH_INC, DMA_TIMING_4
;     DMA_WR2 DMA_SRC_IO, DMA_ADDRH_INC, DMA_TIMING_4
;     DMA_WR4 0x00, 0x40, DMA_MODE_CONTINUOUS                ; WR4: PA_LSB=$00, PA_MSB=$40, mode=%01
;     DMA_WR5 1, 0
;     DMA_WR6 DMA_COMMAND_LOAD
;     DMA_WR6 DMA_COMMAND_READMASK, %01111111
;     DMA_WR6 DMA_COMMAND_ENABLE
; endBlockDmaCode:
; dmaBlockCodeLen equ endBlockDmaCode
; -----------------------------------------------------------
; END OF