[org 0x7c00]

;clear the screen
call clear_the_screen
; set background color
mov bl ,0001
call set_background_color
; seting cursor possition
mov dh , 23
mov dl , 2
call set_cursor_pos

start:
;getting chr from keyboard
call chr_keyboard_input
;cheking for commands
cmp al , "0"
je get_cursor_pos

cmp al , "1"
je clear_the_screen_2

;printing
call print_chr

jmp start

print_chr:
    ;pass the chr in al
     mov ah, 0x0e    ; function number = 0Eh : Display Character
     int 0x10        ; call INT 10h, BIOS video service
     ret
print_string:
    ;pass the string in bx
     mov ah, 0x0e    ; function number = 0Eh : Display Character
     mov al ,[bx] ; AL = code of character to display
     int 0x10        ; call INT 10h, BIOS video service
     inc bx
     mov ax,[bx]
     cmp ax , 0
     jne print_string
     ret
chr_keyboard_input:
    ;output in al
    mov ah , 0
    int 0x16
    ret
get_cursor_pos:
    ;OUTPUT DH = row and Dl = col
    mov aH,03h
    mov bh , 0
    int 0x10
    mov al,DH	
    ret
clear_the_screen:
    mov ah , 00
    mov al, 02
    int 0x10
    mov bx,string_1
    call  print_string
    mov bl ,0001
    call set_background_color
    mov dh , 23
    mov dl , 2
    call set_cursor_pos
    ret

clear_the_screen_2:
    call clear_the_screen
    jmp start
set_background_color:
    ; bl color
    mov ah,0Bh
    mov bh ,00h
    int 0x10 
    ret
set_cursor_pos:
    ; AH=02h	BH = Page Number, DH = Row, DL = Column
    mov ah,02h
    mov bh , 0
    int 0x10
    ret
string_1:
    db "Term OS",10,0
times 510-($-$$)  db 0
db 0x55 , 0xaa