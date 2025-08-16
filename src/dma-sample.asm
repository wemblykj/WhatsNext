;// as pointed out by Peter Ped Helcmanovsky, the OPT switches 
;// must be indented so please copy this comment as well, which will
;// have the correct formatting, also click the Raw button to get plain ascii.
;// no copyright patricia dot curtis at luckyredfish.com


                OPT     --zxnext    
                DEVICE  ZXSPECTRUMNEXT                               ;// tell the assembler we want it for Spectrum Next
                SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
                
                ORG     0x8000
StackEnd:
                ds      127 
StackStart:     db      0        
;//              org StackStart
StartAddress   
MainLoop:       ld      a,r                     ;// black border
                out     ($fe),a        

// Here DE counts down and D and E are OR-ed to check if the loop has completed.

                ld      de,1000                 ;// loop for 1000 times just wasting cycles
Loop1:          dec     de                      ;// take 1 off the 1000
                ld      a,d                     ;// move it to a register we can or with
                or      e                       ;// or with e to set the flags
                jp      nz,Loop1 

                ld      a,1                     ;// change this for different colours
                out     ($fe),a

                ld      a,r
                ld      hl,0x4000
                ld      (hl),a                  ;// clear the first 4096 bytes of memory
                ld      de,0x4001
                ld      bc,0x0fff               ;// copy 4096 bytes from 0x4000 to 0x4001
                call    dma_block_transfer 

;// do another loop wasting more cycles, this time larger band                
                ld      de,2000
Loop2:          dec     de
                ld      a,d
                or      e
                jp      nz,Loop2
;// do the whole thing black and blue again and again
                jp      MainLoop
;//end start 
;// now we save the compiled file so we can either run it or debug it

                INCLUDE "dma-defs.inc"
                INCLUDE "dma-lib.asm"

                INCLUDE "dma-vars.inc"

                SAVENEX OPEN "dma-sample.nex", StartAddress
                SAVENEX CORE 3, 0, 0                                ;// Next core 3.0.0 required as minimum
                SAVENEX CFG  0
                SAVENEX AUTO
                SAVENEX CLOSE   
                ;CSPECTMAP dma-sample.map