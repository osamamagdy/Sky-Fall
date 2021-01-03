.model small


.data

	first_cursor_x db 0
	first_cursor_y db 0
    second_cursor_x db 0
	second_cursor_y db 81
    letter db ?
    is_enter db ?
    is_scroll db ?
.code

;description
main PROC far

    mov ax,@data
    mov ds,ax

    mov ah,0
    mov al,3
    int 10h
   call draw_line

   Mov AH,0 ;initializing COM port
   ;;MOV DX,1 ;;COM2
   MOV AL,0c3H ; BaudRate=4800&&No_Parity&&one_stop_bit&&8_bit_word_len.
   INT 14H

AGAIN: 
   MOV AH,01
   INT 16h ;int16h/ah,01 to check if any key is pressed
   ;if there is a key pressed zf=0 else zf=1
   JZ NEXT
   MOV AH,0
   INT 16h;int16h/ah,0 to check if any key is pressed
   ;and get the key in al
   CMP AL,1BH ;the key was esc key
   JE EXIT
   CALL check_enter
   CALL BackSpace
   MOV DL,AL
   MOV AH,02
   INT 21H
   MOV AH,1;int 14H/Ah,1 to send a character (Al=char)
  ;; MOV DX,01
   INT 14H


NEXT: MOV AH,03 ;int14h/ah,03 to get com2 status(AH=status com2)
      ;;MOV DX,01 ; com2
      INT 14H ;status= D7 D6 ...... D0
      AND AH,01 ;By this Ah=D0 as all other bits become 0 as we and then with 0
      CMP AH,01 ;check D0 and see if there is a character
      JNE AGAIN ;no recieved data go back and monitor the keyboard
      Mov AH,02 ;INT14H/AH,02 RECIEVED A CHAR (AL=CHAR)
     ;; MOV DX,01 
      INT 14H
       ;;TO DISPLAY RECIEVED CHAR USING INT 21H/AH,02
      MOV DL,AL
      MOV AH,02
      INT 21H
      jmp AGAIN


EXIT:
    MOV AH,4CH
    INT 21h

  
  
    

main ENDP



 ;description
draw_line PROC
 	mov ax,0b800h ;text mode 
	mov DI,1920     ; each row 80 column each one 2 bits 80*2*12
	mov es,ax
    mov ah,0fh    ; black background
	mov al,2Dh    ; '-'
	mov cx,80
	rep stosw
    ret
draw_line ENDP






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
      cmp first_cursor_y,11
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
	mov dh,12
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
Backspace proc
cmp Al,08

ret
BackSpace ENDP
END main

