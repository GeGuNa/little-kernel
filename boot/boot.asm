; stage 1 bootloader, load  63.5kb main os into memory at 0x7e00 and jump

[ORG 0x7c00]
   jmp start

   %include "./boot/print.asm"
   
   
start:
   mov ax, 0
   mov ds, ax ; data segment=0
   mov es, ax
   mov ss, ax ; stack starts at 0
   mov sp, 0x5c00 ; stack pointer starts 0x2000 before code - so as to not overwrite anything
   cld ; clear direction flag


  mov ah, 0x00
  mov al, 0x03  ; text mode 80x25 16 colours
  int 0x10
   ; enable A20
   mov ax, 0x2401
   int 0x15

   mov si, boot0msg
   call print

   ; load straight into bootloader1 as this is limited to just 512 bytes
   call read_kernel
   
   mov si, errormsg
   call print

   jmp $ ; infinite loop

read_kernel:
   mov si, boot1loadmsg
   call print

   mov dl, 0x80 ; read from hard drive
   mov ah, 0x02 ; 'read sectors from drive'
   mov al, 120 ; number of sectors to read: 127=63.5KiB
   mov ch, 0 ; cyclinder no
   mov cl, 2 ; sector no [starts at 1]
   mov dh, 0 ; head no
   mov bx, 0 ; set es:bx
   mov es, bx ; first part of memory pointer (should be 0)
   mov bx, 0x9000 ; 512 after our bootloader start 
   int 0x13
  
  jmp  switch_to_32bit

[bits 16]

switch_to_32bit:
    cli             ; Disable interrupts
    lgdt [gdt_descriptor] ; Load the GDT descriptor
    mov eax, cr0    ; Read the control register
    or eax, 0x1     ; Enable protected mode
    mov cr0, eax    ; Write the control register
    jmp CODE_SEG:init_32bit ; Jump far jump to 32-bit code

[bits 32]

%include "./boot/print_32bit.asm"



init_32bit:
    mov ax, DATA_SEG ; Update segment registers
    mov ds, ax      ; Refer to top table
    mov ss, ax      ; "
    mov es, ax      ; "
    mov fs, ax      ; "
    mov gs, ax      ; "

    mov ebp, 0x90000 ; Set the stack pointer
    mov esp, ebp


   mov ebx, msg32bt
   call print32



    call 0x9000 ; Jump to the 32-bit code

    hlt ;stopping exection from this point / halting


msg32bt db "32 bit protected mode", 0

   ; strings
   boot0msg db 'Starting bootloader0', 13, 10, 0 ; label pointing to address of message + CR + LF
   boot1loadmsg db 'Loading bootloader1 from disk', 13, 10, 0 ; label pointing to address of message + CR + LF
   errormsg db 'Unable to load bootloader1', 13, 10, 0 



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



   times 510-($-$$) db 0 ; fill rest of 512 bytes with 0s (-2 due to signature below)
   dw 0xAA55 ; marker to show we're a bootloader to some BIOSes
