;%include "./boot/print.asm"
[bits 16]

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
