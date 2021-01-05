.model small


.data

	first_cursor_x db 0
	first_cursor_y db 0
    letter db ?
    is_enter db ?
    is_scroll db ?
    VALUE db ?

.code

;description
main PROC far

    mov ax,@data
    mov ds,ax

    mov ah,0
    mov al,3
    int 10h

    call initializing
    call draw_line
    call start_sending
    

main ENDP

initializing PROC
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

RECEIVE_VALUE PROC
;Check that Data is Ready
mov dx , 3FDH ; Line Status Register
CHK: in al , dx
test al , 1
JZ CHK ;Not Ready
;If Ready read the VALUE in Receive data register
mov dx , 03F8H
in al , dx
mov VALUE , al
ret
RECEIVE_VALUE ENDP

SEND_VALUE PROC
;Check that Transmitter Holding Register is Empty
mov dx , 3FDH ; Line Status Register
AGAIN: In al , dx ;Read Line Status
test al , 00100000b
JZ AGAIN ;Not empty
;If empty put the VALUE in Transmit data register
mov dx , 3F8H ; Transmit data register
mov al,letter
out dx , al
RET
SEND_VALUE ENDP


start_sending PROC
    test1:
    ;wait for key press
    CHECK: mov ah,1
        int 16h
        jz CHECK
        jmp get_key_pressed

        get_key_pressed:
            mov ah,0
            int 16h
            mov letter,al  ;letter holds the char required to be sent
           

            ;check if key pressed is enter key
            call check_enter
            cmp is_enter,1
            jz here
        
            CALL   SEND_VALUE
            ;set cursor
            mov ah,2 
            mov bh,0
            mov dl,first_cursor_x
            mov dh,first_cursor_y
            int 10h

            mov ah,2
            mov dl,letter
            int 21h
           
            call get_new_position
            here:
            mov is_enter,0

    jmp test1

start_sending ENDP


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
END main