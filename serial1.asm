.MODEL SMALL
.STACK 64
.DATA
	; FIRST CURSOR USED FOR SENT
	First_cursor_X         DB  6
	First_cursor_Y         DB  1

	; SECOND CURSOR USED FOR RECEIVING
	SECOND_CURSOR_X        DB  6
	SECOND_CURSOR_Y        DB  14

	start_position_x       equ 6

	LETTER_SENT            DB  ?
	LETTER_RECEIVING       DB  ?


	Line_status_register   equ 3FDH
	TRANSMIT_DATA_REGISTER equ 3F8H
	Line_Control_Register  equ 3fbh

	end_line               db  76

	IS_ENTER               DB  0
	IS_BACKSPACE           DB  0
	;players Name
	first_chatter          db  'chatter 1 : $'
	second_chatter         db  'chatter 2 : $'

.CODE

MAIN PROC FAR
	                    MOV  AX ,@DATA
	                    MOV  DS,AX
	;set up INITIALIZATION
	                    CALL INITIALIZE
	;CLEAR screen
	                    mov  ah,0
	                    mov  al,3
	                    int  10h

	                    CALL SET_CHATTERS
	                    call draw_line

	;set first cursor position to top left center
	                    MOV  AH,2
	                    MOV  DL,0
	                    MOV  DH ,0
	                    INT  10H



	;check if any letter recevied
	CHECK_RECEIVE:      
	;check if their is letter received
	                    MOV  DX,Line_status_register         	; LINE STATUS resgister
	                    IN   AL,DX
	                    TEST AL,1
	                    JZ   NO_RECIEVE

	;receive register
	                    MOV  DX ,TRANSMIT_DATA_REGISTER
	                    IN   AL ,DX
	                    MOV  LETTER_RECEIVING,AL

	                    CMP  AL,1BH                          	;scan code of ESC
	                    JE   END_CHAT
						   
	                    CMP  AL,8   
				 		JZ  IT_IS_BACK_REC                     	;CHECK IF RECIEVED BACKSPACE TO SET THE VARIABLE
						JMP CHECK_ENTER_REC
			IT_IS_BACK_REC:
	                    MOV  IS_BACKSPACE,1
	                    JMP  GO_TO_LOWER_SCREEN

	CHECK_ENTER_REC:   CMP  AL,13                           	;CHECK IF RECIEVED ENTER
	                    JZ   ITIS_ENTER
	                    JMP  GO_TO_LOWER_SCREEN
	ITIS_ENTER:         
	                    MOV  IS_ENTER,1

	GO_TO_LOWER_SCREEN: CALL Lower_screen
	                    JMP  CHECK_RECEIVE


	;IF NOTHING TO RECIEVE SEND CHARACTER IF ANY
	NO_RECIEVE:         
	                    MOV  AL,0
	                    MOV  AH,01H
	                    INT  16H                             	

	                    CMP  AL,0
	                    JE   CHECK_RECEIVE                   	

	                    MOV  AH,00H                          	
	                    INT  16H
	                    MOV  LETTER_SENT,AL                  	;STORE DATA IN LETTER TO BE SENT
																;LATER


	;--------------------- START SENDING -------------------------
	                    MOV  DX , Line_status_register       	;LINE STATUS REGISTER
	                    IN   AL , DX                         	;READ LINE STATUS
	                    TEST AL , 00100000B
	                    JZ   CHECK_RECEIVE                   	;NOT EMPTY
						   
	                    MOV  DX , TRANSMIT_DATA_REGISTER     	; TRANSMIT DATA REGISTER
	                    MOV  AL,LETTER_SENT
	                    OUT  DX , AL

	                    CMP  AL,27                           	; check if ESC is pressed
	                    JE   END_CHAT

	                    CMP  AL,8
						JZ IT_IS_BACK1
						JMP check_enter_SEND
				IT_IS_BACK1:
	                    MOV  IS_BACKSPACE,1
	                    JMP  GO_TO_UPPER_SCREEN

	check_enter_SEND:   CMP  AL,13                            ;CHECK scan code if ENTER KEY
	                    JNZ  GO_TO_UPPER_SCREEN
	                    MOV  IS_ENTER,1

	GO_TO_UPPER_SCREEN:      CALL upper_screen
	                    	 JMP  CHECK_RECEIVE

	END_CHAT:           
	                  
	                    mov  ah,0
	                    mov  al,3
	                    int  10h
	                    RET
MAIN ENDP


INITIALIZE PROC
	;Set Divisor Latch Access Bit
	                    mov  dx,Line_Control_Register        	; Line Control Register
	                    mov  al,10000000b                    	;Set Divisor Latch Access Bit
	                    out  dx,al                           	;Out it

	; Set LSB byte of the Baud Rate Divisor Latch register.
	                    mov  dx,TRANSMIT_DATA_REGISTER
	                    mov  al,0ch
	                    out  dx,al

	; Set MSB byte of the Baud Rate Divisor Latch register.
	                    mov  dx,3f9h
	                    mov  al,00h
	                    out  dx,al

	; Set port configuration
	                    mov  dx,Line_Control_Register
	                    mov  al,00011011b
	; 0:Access to Receiver buffer, Transmitter buffer
	; 0:Set Break disabled
	; 011:Even Parity
	; 0:One Stop Bit
	; 11:8bits
	                    out  dx,al
	                    RET
INITIALIZE ENDP

	;description
SET_CHATTERS PROC
	                    mov  ah,2                            	;SET POSITION
	                    mov  DX,0H
	                    INT  10H

	                    MOV  AH,09
	                    MOV  DX,OFFSET first_chatter         	;PRINT first_chatter NAME
	                    INT  21H

	                    mov  ah,2                            	;SET POSITION
	                    mov  DX,0D00H
	                    INT  10H
	                    MOV  AH,09
	                    MOV  DX,OFFSET second_chatter        	;PRINT SECOND_chatter NAME
	                    INT  21H
	                    RET
SET_CHATTERS ENDP

	;description
draw_line PROC
	                    MOV  AH,2
	                    mov  dx,12
	                    INT  10H

	                    mov  ax,0b800h                       	;text mode
	                    mov  DI,1920                         	; each row 80 column each one 2 bits 80*2*12
	                    mov  es,ax
	                    mov  ah,0fh                          	; black background
	                    mov  al,'-'                          	; '-'
	                    mov  cx,80
	                    rep  stosw
	                    ret
draw_line ENDP

upper_screen PROC
	                    push ax
	                    push bx
	                    push cx
						PUSH DX
	                    CMP  IS_BACKSPACE,1
	                    JNZ  NOT_BACK
	                    CMP  First_cursor_X,start_position_x 
	                    JG  CAN_BACK
	                    JMP  SET_BACK
						
	CAN_BACK:         
	                    DEC  First_cursor_X                  ; IF IT IS BACKSPACE DEC POSITION X
															 ; AND STORE ' ' IN AL
	SET_BACK:       
	                    MOV  LETTER_SENT,' '                  	;SPACE
	                    JMP  set_new_position


	NOT_BACK:      
	                    CMP  IS_ENTER,1
	                    JE NEW_LINE 
						JMP set_new_position


	NEW_LINE:          

	                    INC  First_cursor_Y                  	;START NEW LINE
	                    MOV  First_cursor_X,start_position_x 	;SET X TO LINE BEGINNING
	                    JMP  CHECK_SCROLL            	;SCROLL ONE LINE


	set_new_position:   
	                    MOV  AH,2
	                    MOV  DL ,First_cursor_X
	                    MOV  DH ,First_cursor_Y
	                    INT  10H
      
	;	PRINT THE CURRENT CHARACTER WITH CERTAIN COLOR
	                    MOV  AH,9
	                    MOV  BH,0
	                    MOV  AL ,LETTER_SENT      ; STORE SENT LETTER IN AL
	                    MOV  CX,1H					; PRINT LETTER 1 TIME
	                    MOV  BL,03H                 ;LIGHT BLUE COLOR	
	                    INT  10H

	                    CMP  IS_BACKSPACE,1  
	                    JE   END_UPPER_CHAT
	                    INC  First_cursor_X
						
						;IF FIRST_CURSOR_X REACHES END OF LINE 76 START NEW LINE
						MOV DL,end_line
	                    CMP  First_cursor_X ,DL   
	                    JNZ  END_UPPER_CHAT
	                    JMP  NEW_LINE
	CHECK_SCROLL: 
			CMP  First_cursor_Y,12
	        JNZ  END_UPPER_CHAT
			JMP SCROLL_UPPER_SCREEN

	SCROLL_UPPER_SCREEN:
					CALL SCROLL_UP  
	                   

	END_UPPER_CHAT:  

	                    MOV  AH,2
	                    MOV  DL ,First_cursor_X     ; SET NEW X-POSITION OF CURSOR
	                    MOV  DH ,First_cursor_Y		 ; SET NEW Y-POSITION OF CURSOR
	                    INT  10H

						MOV  AL,0

	                    MOV  IS_BACKSPACE,0      ;RETURN IS_BACKSPACE,IS_ENTER TO ZERO AGAIN
	                    MOV  IS_ENTER,0
	                    

						POP DX
	                    pop  cx
	                    pop  bx
	                    pop  ax
	                    RET
upper_screen ENDP

;description
;description
SCROLL_UP PROC
	PUSH ax
	PUSH bx
	PUSH cx
	PUSH DX

   MOV  AH,6
	MOV  AL,1                            	; SCROLL THE UPPER PART  BY 1 LINE
	MOV  BH,0                            	; NORMAL VIDEO ATTRIBUTE
	MOV  CH,1                            	;GET POSITION
	MOV  CL,03      				 
	MOV  DH,11
	MOV  DL,79
	INT  10H
	DEC  First_cursor_Y	

	POP dx
	POP CX
	POP BX 
	POP AX
	RET 
SCROLL_UP ENDP

Lower_screen PROC
						PUSH AX
						PUSH bx
						PUSH cx
						PUSH DX

	                    CMP  IS_BACKSPACE,1
	                    JNZ  NOT_BACK2
	                    CMP  SECOND_CURSOR_X,start_position_x
	                    JG  CAN_BACK2
	                    JMP  SET_BACK2

	            
	CAN_BACK2:        
	                    DEC  SECOND_CURSOR_X

	SET_BACK2:      
	                    MOV  AL,' '                           	;SPACE
	                    JMP  set_new_position2

						   
	NOT_BACK2:     
	                    CMP  IS_ENTER,1
						JE NEW_LINE2
	                    JMP  set_new_position2



	NEW_LINE2:         

	                    INC  SECOND_CURSOR_Y
	                    MOV  SECOND_CURSOR_X,start_position_x   ;SET CURSOR_X OF LOWER SCREEN 
	                    JMP  CHECK_SCROLL2			   
	set_new_position2:  

	                    MOV  AH,2
	                    MOV  DL ,SECOND_CURSOR_X ; SET CURSOR POSITION OF 2ND CURSOR
	                    MOV  DH ,SECOND_CURSOR_Y
	                    INT  10H
	

	                    MOV  AH,9                ;PRINT THE RECEIVED LETTER WITH RED COLOR
	                    MOV  BH,0				 
	                    MOV  CX,1H				; one time
	                    MOV  BL,0CH				;RED COLOR
	                    INT  10H
						

	
	                    CMP  IS_BACKSPACE,1
	                    JE   END_LOWER_CHAT
	                    INC  SECOND_CURSOR_X    ; inc X_position of 2nd cursor if it is not backspace
						   
						mov dl,end_line
	                    CMP  SECOND_CURSOR_X ,dl ; if X_position of 2nd cursor reach end of line 
	                    JNE  END_LOWER_CHAT		 
	                    JMP  NEW_LINE2			; start new line	
	CHECK_SCROLL2:
	  				CMP  SECOND_CURSOR_Y,25
	                JNE  END_LOWER_CHAT
					JMP  SCROLL_BOTTOM
	SCROLL_BOTTOM:      
	                CALL SCROLL_DOWN
	                    

	END_LOWER_CHAT: 

	                    MOV  AH,2
	                    MOV  DL ,First_cursor_X	 ;SET NEW CURSOR POSITION X
	                    MOV  DH ,First_cursor_Y  ;SET NEW CURSOR POSITION Y
	                    INT  10H
						   
	;CLEAR FLAGS
	                    MOV  IS_ENTER,0
	                    MOV  IS_BACKSPACE,0
	                    MOV  AL,0

						POP dx
						POP CX
						POP bx
						POP ax

	                    RET
Lower_screen ENDP
 
;description
SCROLL_dOWN PROC
		PUSH ax
		PUSH bx
		PUSH cx
		PUSH DX

	    MOV  AH,6
	    MOV  AL,1
	    MOV  BH,0
	    MOV  CH,14
	    MOV  CL,0
	    MOV  DH,24
	    MOV  DL,79
	    INT  10H
	    DEC  SECOND_CURSOR_Y

		POP dx
		POP CX
		POP BX 
		POP AX
	RET 
SCROLL_dOWN ENDP

END MAIN