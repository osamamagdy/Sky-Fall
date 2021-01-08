.model small


.data

	first_cursor_x db 0
	first_cursor_y db 1
    VALUE_TO_SEND db ?
    is_enter db ?
    is_esc db 0
    is_scroll db ?
    VALUE db ?


    second_cursor_x db 0
	second_cursor_y db 14
     Second_Player_Name  DB '16','?','Second_Player_Name$'
    First_Player_Name  DB '16','?','First_Player_Name$'
    close_message     DB '----------------------------to end chatting press ESC---------------------------$'

.code

;description
main PROC far

    mov ax,@data
    mov ds,ax
    MOV ES,AX

   call chat_module_2
    

main ENDP

;description
chat_module_2 PROC
    

 mov ah,0
    mov al,3
    int 10h


    mov ah,2 
    mov dl,first_cursor_x
    mov dh,first_cursor_y
    int 10h


     mov di, offset First_Player_Name
    add di,2
    call print_string_chat_module_first_player

    mov di, offset Second_Player_Name
    add di,2
    call print_string_chat_module_second_player


    call initializing
    call draw_line
    call print_close_message
    WHILE1_chat_module_2:
     mov ah,2 
    mov dl,first_cursor_x
    mov dh,first_cursor_y
    int 10h
    call READ_FROM_KEYBOAD
    call RECEIVE_VALUE
    cmp is_esc,1
    je end_chat_module_2
    jmp WHILE1_chat_module_2

    end_chat_module_2:
    ret
chat_module_2 ENDP
print_close_message PROC
    mov dl,0
    mov dh,24d
    mov di,offset close_message
    print_close_message_loop:
    mov ah,2 
    int 10h 
     mov al,[di]
    cmp al,'$'
    je print_close_message_ret
    mov ah,09h
     mov al,[di]
     mov bh,0
     mov bl,0fh ;white color
     mov cx,1
    int 10h
    inc di 
    inc dl
    jmp print_close_message_loop
    print_close_message_ret:
    ret

print_close_message ENDP

print_string_chat_module_first_player PROC
    mov dl,0
    mov dh,0
    print_string_chat_module_loop:
     mov ah,2 
    
    int 10h
    mov al,[di]
    cmp al,'$'
    je ret_print_string_chat_module    

     mov ah,09h
     mov al,[di]
     mov bh,0
     mov bl,0fh ;white color
     mov cx,1
    int 10h
    inc di 
    inc dl
    jmp print_string_chat_module_loop
    ret_print_string_chat_module:
     mov ah,09h
     mov al,':'
     mov bh,0
     mov bl,0fh ;white color
     mov cx,1
    int 10h

    ret
print_string_chat_module_first_player ENDP

print_string_chat_module_second_player PROC
    mov dl,0
    mov dh,13d
    print_string_chat_module_loop_second:
     mov ah,2 
    
    int 10h
    mov al,[di]
    cmp al,'$'
    je ret_print_string_chat_module_second   

     mov ah,09h
     mov al,[di]
     mov bh,0
     mov bl,0fh ;white color
     mov cx,1
    int 10h
    inc di 
    inc dl
    jmp print_string_chat_module_loop_second
    ret_print_string_chat_module_second:
     mov ah,09h
     mov al,':'
     mov bh,0
     mov bl,0fh ;white color
     mov cx,1
    int 10h

    ret
print_string_chat_module_second_player ENDP

initializing PROC                 ;;GOOD PROC
    ;Set Divisor Latch Access Bit
    mov dx,3fbh ; Line Control Register
    mov al,10000000b ;Set Divisor Latch Access Bit
    out dx,al ;Out it

    ; Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h
    mov al,0ch
    out dx,al

    ; Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al

    ; Set port configuration
    mov dx,3fbh
    mov al,00011011b
    ; 0:Access to Receiver buffer, Transmitter buffer
    ; 0:Set Break disabled
    ; 011:Even Parity
    ; 0:One Stop Bit
    ; 11:8bits
    out dx,al
    ret  
initializing ENDP

 ;description
draw_line PROC                        ;;GOOD PROC 
 	mov ax,0b800h ;text mode 
	mov DI,1920     ; each row 80 column each one 2 bits 80*2*12
	mov es,ax
    mov ah,0fh    ; black background
	mov al,2Dh    ; '-'
	mov cx,80
	rep stosw
    ret
draw_line ENDP



; SEND_VALUE PROC                                 ;; GOOD PROC

; ;Check that Transmitter Holding Register is Empty
; mov dx , 3FDH ; Line Status Register
; AGAIN: In al , dx ;Read Line Status
; test al , 00100000b
; JZ AGAIN ;Not empty
; ;If empty put the VALUE in Transmit data register
; mov dx , 3F8H ; Transmit data register
; mov al,VALUE_TO_SEND
; out dx , al
; RET
; SEND_VALUE ENDP


PRINT_RECEIVED PROC
    
   

        ;get_key_pressed:
            ; mov ah,0
            ; int 16h
            ;mov VALUE,al  ; holds the char required to be sent
            mov al,VALUE

            ;check if key pressed is enter key
            call check_enter
            cmp is_enter,1
            jz here
        
            ;CALL   SEND_VALUE
            ;set cursor
            mov ah,2 
            mov bh,0
            mov dl,first_cursor_x
            mov dh,first_cursor_y
            int 10h

            mov ah,09h
            mov al,VALUE
            mov bh,0
            mov bl,0fh ;white color
            mov cx,1
            int 10h
           
            call get_new_position
            here:
            mov is_enter,0
            mov di, offset First_Player_Name
            add di,2
            call print_string_chat_module_first_player
            call print_close_message
            ret

PRINT_RECEIVED ENDP


RECEIVE_VALUE PROC                            ;; GOOD PROC
;Check that Data is Ready
mov dx , 3FDH ; Line Status Register
 in al , dx
test al , 1
JZ END_RECEIVE_VALUE ;Not Ready
;If Ready read the VALUE in Receive data register
mov dx , 03F8H
in al , dx
mov VALUE , al

cmp al,1Bh
jne continue_receive_value
mov is_esc,1
continue_receive_value:
CALL  PRINT_RECEIVED

END_RECEIVE_VALUE:
ret
RECEIVE_VALUE ENDP

check_enter PROC
    cmp al,0dh
    jnz end_enter
    ; cmp first_cursor_y,11
    ; jz 
    enter_action:
        cmp first_cursor_y,11
        jz call_scroll1
        inc first_cursor_y
        mov first_cursor_x,0
        jmp continue
        call_scroll1:
            call check_scroll
        continue:
        mov is_enter,1
        mov ah,2 
        mov bh,0
        mov dl,first_cursor_x
        mov dh,first_cursor_y
        int 10h
    end_enter:        
    ret
check_enter ENDP
;description

get_new_position PROC
    cmp first_cursor_x,75
    jz new_line 
       inc first_cursor_x      
       jmp return
    new_line:
      cmp first_cursor_y,11d
      jz call_scroll
      inc first_cursor_y            ; move to new line
      mov first_cursor_x,0
      jmp return
      call_scroll:
         call check_scroll
       return:  
    ret
get_new_position ENDP


 ;description
check_scroll PROC
    mov ax,0601h
    mov bh,00
    mov ch,0
	mov cl,0
	mov dh,11
	mov dl,79
    int 10h
    call update_line
    mov first_cursor_x,0
    MOV first_cursor_Y,11
    ret
check_scroll ENDP

;description
update_line PROC
    mov ax,0b800h
	mov di,1760   ; each row 80 column each one 2 bits 80*2*11
	mov es,ax
	mov ah,07h
	mov al,20h
	mov cx,80  ;
	rep stosw
;draw separator
    call draw_line
   
    ret
update_line ENDP



draw_line_written PROC                        ;;GOOD PROC 
 	mov ax,0b800h ;text mode 
	mov DI,1920     ; each row 80 column each one 2 bits 80*2*12
	mov es,ax
    mov ah,0fh    ; black background
	mov al,2Dh    ; '-'
	mov cx,80
	rep stosw
    ret
draw_line_written ENDP


update_line_written PROC
    mov ax,0b800h
	mov di,1760   ; each row 80 column each one 2 bits 80*2*11
	mov es,ax
	mov ah,07h
	mov al,20h
	mov cx,80  ;
	rep stosw
;draw separator
    call draw_line_written
   
    ret
update_line_written ENDP




check_scroll_written PROC
    mov ax,0601h
    mov bh,00
    mov ch,13d
	mov cl,0
	mov dh,23d
	mov dl,79
    int 10h
    call update_line_written
    mov second_cursor_x,0
    MOV second_cursor_Y,23d
    ret
check_scroll_written ENDP



check_enter_written PROC
    cmp al,0dh
    jnz end_enter_written
    ; cmp first_cursor_y,11
    ; jz 
   ; enter_action:
        cmp second_cursor_y,23
        jz call_scroll1_written
        inc second_cursor_y
        mov second_cursor_x,0
        jmp continue_check_enter_written
        call_scroll1_written:
            call check_scroll_written
        continue_check_enter_written:
        mov is_enter,1
        mov ah,2 
        mov bh,0
        mov dl,second_cursor_x
        mov dh,second_cursor_y
        int 10h
    end_enter_written:        
    ret
check_enter_written ENDP
;description


get_new_position_written PROC
    cmp second_cursor_x,75
    jz new_line_written 
       inc second_cursor_x      
       jmp end_get_new_position_written
    new_line_written:
      cmp second_cursor_y,23d
      jz call_scroll_written
      inc second_cursor_y            ; move to new line
      mov second_cursor_x,0
      jmp end_get_new_position_written
      call_scroll_written:
         call check_scroll_written
       end_get_new_position_written:  
    ret
get_new_position_written ENDP



PRINT_WRITTEN PROC
    
   

       
            mov al,VALUE_TO_SEND

            ;check if key pressed is enter key
            call check_enter_written
            cmp is_enter,1
            jz here_written
        
            ;CALL   SEND_VALUE
            ;set cursor
            mov ah,2 
            mov bh,0
            mov dl,second_cursor_x
            mov dh,second_cursor_y
            int 10h

            mov ah,09h
            mov al,VALUE_TO_SEND
            mov bh,0
            mov bl,0fh ;white color
            mov cx,1
            int 10h
           
            call get_new_position_written
            here_written:
            mov is_enter,0
            mov di, offset Second_Player_Name
            add di,2
            call print_string_chat_module_second_player
            call print_close_message
            ret

PRINT_WRITTEN ENDP





SEND_VALUE PROC                                 ;; GOOD PROC

;Check that Transmitter Holding Register is Empty
mov dx , 3FDH ; Line Status Register
AGAIN: In al , dx ;Read Line Status
test al , 00100000b
JZ AGAIN ;Not empty
;If empty put the VALUE in Transmit data register
mov dx , 3F8H ; Transmit data register
mov al,VALUE_TO_SEND
out dx , al
RET
SEND_VALUE ENDP


READ_FROM_KEYBOAD PROC
    MOV AH,1
    INT 16H
    JZ NO_KEY_PRESSED
    MOV AH,0 
    INT 16H
    MOV VALUE_TO_SEND,AL

    cmp al,1Bh 
    jne continue_read_from_keyboard
    mov is_esc,1

    continue_read_from_keyboard:
    CALL   SEND_VALUE
    CALL PRINT_WRITTEN
    JMP END_READ_FROM_KEYBOARD
    NO_KEY_PRESSED:
    MOV VALUE_TO_SEND,0
    END_READ_FROM_KEYBOARD:
    
RET
READ_FROM_KEYBOAD ENDP



END main