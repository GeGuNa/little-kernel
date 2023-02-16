; ------------------------------------------------------------------
; The gdt file is used to define the global descriptor table (gdt) |
; for the kernel. The gdt is used to define the memory segments.   |
; ------------------------------------------------------------------

; -------------------------------------------------------------------------------------------
; 0x0 is a null descriptor                                                                  |
; Flags ->                                                                                  |
; 10011010b = 0x9A -> 1001 = 1 (present), 0 (ring 0), 1 (code), 0 (conforming), 1 (readable)|
; 11011010b = 0xDA -> 1101 = 1 (present), 1 (ring 3), 1 (code), 0 (conforming), 1 (readable)|
; -------------------------------------------------------------------------------------------

gdt_start:
    dq 0x0          ; Base address of our segments


gdt_code:
    dw 0xffff       ; Segment length -> bits 0-15
    dw 0x0          ; Base address -> bits 0-15
    db 0x0          ; Base address -> bits 16-23
    db 10011010b    ; Flags -> 8 bits
    db 11001111b    ; Flags -> 4 bits + segment length -> bits 16-19
    db 0x0          ; Base address -> bits 24-31

gdt_data:
    dw 0xffff       ; Segment length -> bits 0-15
    dw 0x0          ; Base address -> bits 0-15
    db 0x0          ; Base address -> bits 16-23
    db 10010010b    ; Flags -> 8 bits
    db 11001111b    ; Flags -> 4 bits + segment length -> bits 16-19
    db 0x0          ; Base address -> bits 24-31

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of the gdt (16 bits)
    dd gdt_start    ; Address of the gdt (32 bits)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
