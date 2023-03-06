[org 0x7c00]

;normal clear
mov ah , 00
mov al, 02
int 0x10
;set video mode
call set_graphic_mode
;loading animation
mov al, 10
mov bx , 70
mov ax, 10
mov dl,5
call _print_line
;normal clear
mov ah , 00
mov al, 02
int 0x10
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
    call set_graphic_mode
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
set_graphic_mode:
    ; al = 10h
    ; AH=00h	
    ; mov ah,00h
    ; mov al , 10h
    ; int 0x10
    mov ah , 00h
    mov al , 13h
    int 10h
    ret
get_time:
    ; find time
    mov ah,2ch
    int 21h ; outputs time in cl


; al color
; bx starting
; ax len
; dl  delay
_print_line:
inc bx
mov ah,  0ch
mov bh , 00h
mov cx , bx ; x
mov dx , 90 ; y
int 10h
call _delay
cmp ax  , bx
jne _print_line
ret
_delay:
MOV     CX, si
MOV     DX, 4240h
MOV     AH, 86H
INT     15H
ret

string_1:
    db "Term OS",10,0


times 510-($-$$)  db 0
db 0x55 , 0xaa