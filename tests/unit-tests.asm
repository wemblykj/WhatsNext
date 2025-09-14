    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    DEVICE  ZXSPECTRUMNEXT

    ORG $8000
     
    INCLUDE "unit_tests.inc"

; -----------------------------------------------------------
; Initialize unit tests
; -----------------------------------------------------------
    UNITTEST_INITIALIZE
    ; No special initialization needed
    ret

; -----------------------------------------------------------
; Unit tests using DeZog unit testing framework
; -----------------------------------------------------------

unit_test_entry:
    INCLUDE "dma/dma-defs-tests.asm"

;===========================================================================
; Stack.
;===========================================================================


; Stack: this area is reserved for the stack
STACK_SIZE: equ 100    ; in words


; Reserve stack space
    defw 0  ; WPMEM, 2
stack_bottom:
    defs    STACK_SIZE*2, 0
stack_top:
    ;defw 0
    defw 0  ; WPMEM, 2

    SAVENEX OPEN "build/unit-tests.nex", unit_test_entry, stack_top
    SAVENEX CORE 3, 1, 5
    SAVENEX CFG 7   ; Border color
    SAVENEX AUTO
    SAVENEX CLOSE