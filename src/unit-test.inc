; -----------------------------------------------------------
; File:        unit-test.inc
; Project:     WemblyKJ Next - Unit Test Framework
; Description: Generic unit test runner for sjasmplus modules.
;              Provides macros and a test runner entry point.
;              Each test module should define its own TestsTable
;              and NumTests, and include this file.
; -----------------------------------------------------------

; -----------------------------------------------------------
; SECTION: Macros
; -----------------------------------------------------------
; Macro to define a test (collects test addresses in a table)
macro TEST name
    .name:
endm

macro ENDT
    ; End of test
endm

; -----------------------------------------------------------
; SECTION: Test Runner Entry Point
; -----------------------------------------------------------
; The test module must define:
;   TestsTable:
;       dw Test1
;       dw Test2
;   NumTests: equ ($ - TestsTable) / 2

Start:
    ld hl, TestsTable
    ld b, NumTests
RunNextTest:
    ld a, b
    or a
    ret z
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    push bc
    push hl
    ld hl, de
    call TestRunner
    pop hl
    pop bc
    djnz RunNextTest
    ret

TestRunner:
    ; HL = test address
    push hl
    call (hl)
    pop hl
    ret

; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------