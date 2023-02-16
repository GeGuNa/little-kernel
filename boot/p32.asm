; -------------------------------------------------------------------------------------------------------
; CLI               Disables the cpu interrupts                                                         |
; LGDT              Loads the Global Descriptor Table                                                   |
; CR0               Control Register 0 -> Enables protected mode                                        |
; JMP               Jumps to the kernel -> Far jump so that we flush the cpu of all 16 bit instructions |
; {ds, ss, es, fs, gs} to point to our single 4GB segment                                               |
; setup new stack by setting the                                                                        |
;       32 bit bottom pointer -> (EBP)                                                                  |
;       and the stack pointer -> (EBX)                                                                  |
; Jump back to mbr.asm to give control back to the bootloader in 32 bit mode                            |
; -------------------------------------------------------------------------------------------------------

[bits 16]

switch_to_32bit:
    cli             ; Disable interrupts
    lgdt [gdt_descriptor] ; Load the GDT descriptor
    mov eax, cr0    ; Read the control register
    or eax, 0x1     ; Enable protected mode
    mov cr0, eax    ; Write the control register
    jmp CODE_SEG:init_32bit ; Jump far jump to 32-bit code

[bits 32]
init_32bit:
    mov ax, DATA_SEG ; Update segment registers
    mov ds, ax      ; Refer to top table
    mov ss, ax      ; "
    mov es, ax      ; "
    mov fs, ax      ; "
    mov gs, ax      ; "

    mov ebp, 0x90000 ; Set the stack pointer
    mov esp, ebp

    call BEGIN_32BIT ; Jump to the 32-bit code
