; as pointed out by Peter Ped Helcmanovsky, the OPT switches 
; must be indented so please copy this comment as well, which will
; have the correct formatting, also click the Raw button to get plain ascii.
; no copyright patricia dot curtis at luckyredfish.com


                OPT          
                DEVICE  ZXSPECTRUMNEXT                               ; tell the assembler we want it for Spectrum Next
                SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
                
                ORG     $8000
StackEnd:
                ds      127 
StackStart:     db      0        
;               org StackStart
StartAddress   
                ei
	            nextreg	$08,%11010000

; now we do a DMA block transfer to clear a block of memory 
                ld      de,$4000
                ld      bc,$1800 
                call    DMA_BLOCK_CLEAR

MainLoop:       halt
                call    wait_vsync              ; wait for the next vsync to start
                ld      a,0                     ; black border
                out     ($fe),a        

; Here DE counts down and D and E are OR-ed to check if the loop has completed.

                ld      de,1000                 ; loop for 1000 times just wasting cycles
Loop1:          dec     de                      ; take 1 off the 1000
                ld      a,d                     ; move it to a register we can or with
                or      e                       ; or with e to set the flags
                jp      nz,Loop1 

                ld      a,2                     ; change this for different colours
                out     ($fe),a
             
; update 'clear' byte to be propogate by the pre-programmed DMA controller
                ld      hl,$4000                
                ld      a,r
                ld      (hl),a                  ; clear the first 4096 bytes of memory
                call    DMA_RESTART

; now we do a DMA block transfer to clear a block of memory  
                ;ld      de,$4000
                ;ld      bc,$1800 
                ;call    DMA_BLOCK_SET
                
; now we do a DMA block transfer to seta block of memory
                ;ld      hl,$4000
                ;ld      a,7
                ;ld      (hl),a                  ; clear the first 4096 bytes of memory
                ;ld      de,$4001
                ;ld      bc,$17FF                ; copy 6143 bytes from 0x4000 to 0x4001
                ;call    DMA_BLOCK_TRANSFER 

                ld      a,1                      ; change this for different colours
                out     ($fe),a 

; do another loop wasting more cycles, this time larger band                
                ld      de,2000
Loop2:          dec     de
                ld      a,d
                or      e
                jp      nz,Loop2
; do the whole thing black and blue again and again
                jp      MainLoop
; end start 
; now we save the compiled file so we can either run it or debug it

wait_vsync:
                ld bc, $243B                    ; REG SELECT port
                ld a, $1F                       ; Register $1F (VSYNC reading)
                out (c), a                      ; Select register $1F
                
                ld bc, $253B                    ; REG DATA port
wait_loop:
                in a, (c)                       ; Read register value
                and 1                           ; Check if bit 0 is set (VSYNC active)
                jr z, wait_loop                 ; If not, keep waiting
                ret

                INCLUDE "dma-defs.inc"
                INCLUDE "dma-macros.inc"
                INCLUDE "dma-lib.asm"

                INCLUDE "dma-vars.inc"

                SAVENEX OPEN "build/dma-sample.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                ; Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE   
                ;CSPECTMAP dma-sample.map