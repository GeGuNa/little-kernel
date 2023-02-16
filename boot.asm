;
; An experimental bootloader for x86 with second stage
; by FlierMate (Oct 10, 2021)
;
; With reference to Redox OS bootsector.asm
;
format binary as 'img'
org 7C00h

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [disk], dl
    mov byte [0b8000h],'W'
    mov byte [0b8000h+1],10
    mov byte [0b8000h+2],'o'
    mov byte [0b8000h+3],10
    mov byte [0b8000h+4],'w'
    mov byte [0b8000h+5],10
    mov byte [0b8000h+6],32
    mov byte [0b8000h+7],7
    mov byte [0b8000h+8],'O'
    mov byte [0b8000h+9],10
    mov byte [0b8000h+10],'S'
    mov byte [0b8000h+11],10  
    mov byte [0b8000h+12],32
    mov byte [0b8000h+13],7    
    mov byte [0b8000h+14],32
    mov byte [0b8000h+15],7  
    
    mov ax,1        ;start sector
    mov bx, 0x7e00  ;offset of buffer
    mov cx,1        ;number of sectors (512 bytes each)
    xor dx, dx

    call _load
    jmp 0:0x7e00    ;2nd stage
     
;Reference: Redox OS bootsector.asm

; load some sectors from disk to a buffer in memory
; buffer has to be below 1MiB
; IN
;   ax: start sector
;   bx: offset of buffer
;   cx: number of sectors (512 Bytes each)
;   dx: segment of buffer
; CLOBBER
;   ax, bx, cx, dx, si
; TODO rewrite to (eventually) move larger parts at once
; if that is done increase buffer_size_sectors in startup-common to that (max 0x80000 - startup_end)

;Reference: Redox OS bootsector.asm
_load:
    mov dword [DAPACK.addr], eax
    mov [DAPACK.buf], bx
    mov [DAPACK.count], cx
    mov [DAPACK.seg], dx

    call print_dapack

    mov dl, [disk]
    mov si, DAPACK
    mov ah, 0x42
    int 0x13
    jc error
    ret

;Reference: Redox OS bootsector.asm    
print_dapack:
    mov bx, [DAPACK.addr + 2]
    call print_hex
    mov bx, [DAPACK.addr]
    call print_hex
    mov al, ' '
    call print_char
    mov bx, [DAPACK.count]
    call print_hex
    mov al, ' '
    call print_char
    mov bx, [DAPACK.seg]
    call print_hex
    mov al, ' '
    call print_char
    mov bx, [DAPACK.buf]
    call print_hex
    ret

;Reference: Redox OS bootsector.asm
; print a character
print_char:
    pusha
    mov bx, 7
    mov ah, 0x0e
    int 0x10
    popa
    ret

;Reference: Redox OS bootsector.asm
; print a number in hex
print_hex:
    mov cx, 4
.lp:
    mov al, bh
    shr al, 4
    cmp al, 0xA
    jb .below_0xA
    add al, 'A' - 0xA - '0'
.below_0xA:
    add al, '0'
    call print_char
    shl bx, 4
    loop .lp
    ret    
    
error:
    mov byte [0b8000h+2000],'E'
    mov byte [0b8000h+2001],12
    mov byte [0b8000h+2002],'r'
    mov byte [0b8000h+2003],12
    mov byte [0b8000h+2004],'r'
    mov byte [0b8000h+2005],12
    mov byte [0b8000h+2006],'o'
    mov byte [0b8000h+2007],12
    mov byte [0b8000h+2008],'r'
    mov byte [0b8000h+2009],12
    mov byte [0b8000h+2010],32
    mov byte [0b8000h+2011],7  
    mov byte [0b8000h+2012],32
    mov byte [0b8000h+2013],7    
    mov byte [0b8000h+2014],32
    mov byte [0b8000h+2015],7  

;Reference: Redox OS bootsector.asm
.halt:
    cli
    hlt
    jmp .halt
        
disk   db 0

;Reference: Redox OS bootsector.asm
DAPACK:
        db 0x10
        db 0
.count  dw 0 ; int 13 resets this to # of blocks actually read/written
.buf    dw 0 ; memory buffer destination address (0:7c00)
.seg    dw 0 ; in memory page zero
.addr   dw 0 ; put the lba to read in this spot
.addr2  dw 0
                   
db 7C00h+510-$ DUP (0)
dw 0AA55h

;db 0x0100000-($ - $$) DUP (0)

;
; 2nd sector
;

start2:
    ;Reference: Redox OS bootsector.asm
    ; enable A20-Line via IO-Port 92, might not work on all motherboards
    in al, 0x92
    or al, 2
    out 0x92, al

    ;call kernel_main
    
    mov byte [0b8000h+2000],'W'
    mov byte [0b8000h+2001],10
    mov byte [0b8000h+2002],'e'
    mov byte [0b8000h+2003],10
    mov byte [0b8000h+2004],'l'
    mov byte [0b8000h+2005],10
    mov byte [0b8000h+2006],'c'
    mov byte [0b8000h+2007],10
    mov byte [0b8000h+2008],'o'
    mov byte [0b8000h+2009],10
    mov byte [0b8000h+2010],'m'
    mov byte [0b8000h+2011],10  
    mov byte [0b8000h+2012],'e'
    mov byte [0b8000h+2013],10    
    mov byte [0b8000h+2014],32
    mov byte [0b8000h+2015],7  
    jmp $
          
db 512-($ - start2) DUP (0)
