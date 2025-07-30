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
; SECTION: Temporary Variables
; -----------------------------------------------------------
CurrentTestIndex: db 0

; -----------------------------------------------------------
; SECTION: Test Runner Entry Point
; -----------------------------------------------------------
; The test module must define:
;   TestsTable:
;       dw Test1
;       dw Test2
;   NumTests: equ ($ - TestsTable) / 2

Start:
    ; Clear ResultsTable before running tests
    ld hl, ResultsTable
    ld b, NumTests
.clear_results:
    ld (hl), 0
    inc hl
    djnz .clear_results

    ld hl, TestsTable
    ld b, NumTests
    ld ix, 0                ; IX will be our test index
RunNextTest:
    ld a, b
    or a
    ret z
    ld e, (hl)
    inc hl
    ld d, (hl)
    inc hl
    ld a, ix
    ld (CurrentTestIndex), a    ; Store current test index

    ; Set test state to 'running' (3)
    ld hl, ResultsTable
    add l, a
    ld (hl), 3

    push bc
    push hl
    ld hl, de
    call TestRunner
    pop hl
    pop bc

    ; If test did not fail (still 3), set as success (1)
    ld a, (CurrentTestIndex)
    ld hl, ResultsTable
    add l, a
    ld a, (hl)
    cp 3
    jr nz, .skip_set_success
    ld (hl), 1
.skip_set_success:

    inc ix
    djnz RunNextTest
    ret

TestRunner:
    ; HL = test address
    push hl
    call (hl)
    pop hl
    ret

; -----------------------------------------------------------
; Macro: assert_mem_equal
; Compares BC bytes at HL (actual) and DE (expected).
; If mismatch, jumps to AssertFail label (user can define).
; Usage: 
;   ld hl, actual_data
;   ld de, expected_data
;   ld bc, length
;   call assert_mem_equal
; -----------------------------------------------------------
assert_mem_equal:
    push hl
    push de
    push bc
.assert_loop:
    ld a, b
    or c
    jr z, .assert_pass
    ld a, (hl)
    cp (de)
    jr nz, AssertFail
    inc hl
    inc de
    dec bc
    jr .assert_loop
.assert_pass:
    pop bc
    pop de
    pop hl
    ret

; User should define AssertFail label in their test file to handle failures.
; Example:
; AssertFail:
;     ; handle failure (e.g., set a flag, halt, etc.)
;
; -----------------------------------------------------------
; END OF FILE
; -----------------------------------------------------------

AssertFail:
    ld a, (CurrentTestIndex)
    ld hl, ResultsTable
    add l, a
    ld (hl), 2        ; 2 = fail
    ret