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

    call  initializing
    call  draw_line
    mov ah,2
    mov dx,0h
    int 10h
    while1:
    
    call RECEIVE_VALUE

    jmp while1
    ; call draw_line
    ; call start_sending
    

main ENDP

PRINT_RECEIVED PROC
mov dl, VALUE
mov ah, 2h
int 21h
PRINT_RECEIVED ENDP

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
CALL  PRINT_RECEIVED

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
mov al,VALUE
out dx , al
RET
SEND_VALUE ENDP




END MAIN
