[bits 16]

print_ch:
   ; print char at al
   mov ah, 0x0E ; teletype output mode for int 10h
   mov bh, 0 ; page number
   int 0x10
   ret

print:
   .ch_loop: ; loop for each char
      lodsb ; load str into al
      cmp al, 0 ; zero=end of str
      jz .done ; get out
      call print_ch
      jmp .ch_loop
   .done:
      ret

print_digit:
   ; al
   add al, 48 ; convert digit to ascii

   call print_ch

   ret

; number printed in reverse order. breaks with numbers >~250
print_num:
   ; IN: unsigned int, ax
   ; call print_digit

   .loop:
      mov dx, 0
      mov cx, 10
      div cx ; ax/cx 
      mov bx, ax
      ; remainder = dx, result = bx

      mov al, dl
      call print_digit

      ; if bx > 0
      mov ax, bx
      cmp bx, 0
      jg .loop

      jmp .done

      ; end while

      .done:
         ret
