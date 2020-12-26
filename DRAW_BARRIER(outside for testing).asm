MACRO_DRAW_BARRIER1 MACRO x,y                      		;x,y are the postion of the upper left vertex
	                    MOV  X_BARRIER1,x
	                    MOV  Y_BARRIER1,y
	                    call CHECK_OVERLAPPING_BARRIER1  ;check if it overlaps with barrier2

ENDM 

MACRO_DRAW_BARRIER2 MACRO x,y                      		;x,y are the postion of the upper left vertex
	                    MOV  X_BARRIER2,x
	                    MOV  Y_BARRIER2,y
	                    call CHECK_OVERLAPPING_BARRIER2  ;check if it overlaps with barrier 1

ENDM 



.model small    ; Code and Data max 64K
.stack 100h     ; Only 256 bytes of stack
.data                		; Start giving some data...


	;VARIABLES USED IN THE PROCS OF DRAWING THE BARRIER
	LEN          DW  100d	;used by the draw barrier proc
	WID          DW  100d	;used by the draw barrier proc
	LENMAX       DW  252d	;used by the draw barrier proc
	WIDMAX       DW  152d	;used by the draw barrier proc

	X_BARRIER1   DW  0   	; xpos of barrier1
	Y_BARRIER1   DW  0   	; ypos of barrier1

	X_BARRIER2   DW  0   	; xpos of barrier2
	Y_BARRIER2   DW  0   	; ypos of barrier2
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;#DEFINES FOR THE LENGTH AND SIZE OF THE BARRIER
	LEN_BARRIER  EQU 75D
	WID_BARRIER  EQU 35D
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;SCREEN SIZE IN PIXELS
	SCREEN_MAX_X EQU 319D
	SCREEN_MAX_Y EQU 199D
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

.code                                                                            		; Start writing code...

main proc far

	                               mov                 ax, @DATA
	                               mov                 ds,ax
   
	                               MOV                 AH,0
	                               MOV                 AL,04H
	                               INT                 10H
 
	                               CALL                CLEAR_SCREEN
                  	                     

	             
	; MACRO_DRAW_BARRIER2 50,50

	                               MACRO_DRAW_BARRIER1 50,50





	FOREVER:                       
	                               JMP                 FOREVER


	                               mov                 AH,4ch
	                               int                 21h


main endp

DRAWRECTANGLE proc

	                               PUSH                LEN
	PRINTL:                        
	                               MOV                 AH,0CH                        	;draw pixel int
	                               MOV                 AL,7H                         	;color wanted
	                               MOV                 BH,0H                         	;page1
	                               MOV                 CX,LEN                        	;x pos
	                               MOV                 DX,wid                        	;y pos
	                               INT                 10H
	                               INC                 LEN
	                               MOV                 BX,LENMAX
	                               CMP                 LEN,BX
	                               JNZ                 PRINTL


	                               POP                 LEN

	                               PUSH                WID
	PRINTW:                        
	                               MOV                 AH,0CH
	                               MOV                 AL,7H
	                               MOV                 BH,0H
    
	                               MOV                 CX,LEN
	                               MOV                 DX,WID
	                               INT                 10H
	                               INC                 WID
	                               MOV                 BX,WIDMAX
	                               INC                 BX
	                               CMP                 WID,BX
	                               JNZ                 PRINTW
   
	                               POP                 WID
	                               PUSH                LEN

    
	PRINTL2:                       
	                               MOV                 AH,0CH
	                               MOV                 AL,7H
	                               MOV                 BH,0H
    
	                               MOV                 CX,LEN
	                               MOV                 DX,WIDMAX
	                               INT                 10H
	                               INC                 LEN
	                               MOV                 BX,LENMAX
	                               CMP                 LEN,BX
	                               JNZ                 PRINTL2

	                               POP                 LEN

	                               PUSH                WID

	              
	PRINTW2:                       
	                               MOV                 AH,0CH
	                               MOV                 AL,7H
	                               MOV                 BH,0H
    
	                               MOV                 CX,LENMAX
	                               MOV                 DX,WID
	                               INT                 10H
	                               INC                 WID
	                               MOV                 BX,WIDMAX
	                               INC                 BX
	                               CMP                 WID,BX
	                               JNZ                 PRINTW2
	                               POP                 WID


	                               RET
DRAWRECTANGLE ENDP

FILLRECTANGLE proc
	                               PUSH                LEN
	FILL:                          
	                               PUSH                WID
	FILLINNER:                     


	                               MOV                 AH,0CH
	                               MOV                 AL,7H
	                               MOV                 BH,0H
    
	                               MOV                 CX,LEN
	                               MOV                 DX,WID
	                               INT                 10H

	                               MOV                 BX,WIDMAX
	                               INC                 WID
	                               CMP                 WID,BX
	                               JNZ                 FILLINNER
	                               POP                 WID

	                               INC                 LEN
	                               MOV                 BX,LENMAX
	                               CMP                 LEN,BX
	                               JNZ                 FILL

	                               POP                 LEN
	                               RET
FILLRECTANGLE ENDP


CLEAR_SCREEN PROC NEAR
	                               MOV                 AH,00h                        	;set the configuration to video mode
	                               MOV                 AL,13h                        	;choose the video mode 320x200
	                               INT                 10h                           	;execute the configuration
		
	                               MOV                 AH,0fh                        	;set the configuration
	                               MOV                 BH,00h                        	;to the background color
	                               MOV                 BL,00h                        	;choose black as background color
	                               INT                 10h                           	;execute the configuration
			
	                               RET
CLEAR_SCREEN ENDP

DRAW_BARRIER1 PROC NEAR
	                               mov                 Ax,X_BARRIER1
	                               mov                 LEN,Ax
	                               add                 Ax,LEN_BARRIER
	                               mov                 LENMAX,ax
	                               mov                 ax,Y_BARRIER1
	                               mov                 WID,ax
	                               add                 ax,WID_BARRIER
	                               mov                 WIDMAX,ax
								   
								   
	                               CALL                DRAWRECTANGLE
	                               CALL                FILLRECTANGLE

	                               RET
DRAW_BARRIER1 endp

DRAW_BARRIER2 PROC NEAR


	                               mov                 Ax,X_BARRIER2
	                               mov                 LEN,Ax
	                               add                 Ax,LEN_BARRIER
	                               mov                 LENMAX,ax
	                               mov                 ax,Y_BARRIER2
	                               mov                 WID,ax
	                               add                 ax,WID_BARRIER
	                               mov                 WIDMAX,ax
	                               CALL                DRAWRECTANGLE
	                               CALL                FILLRECTANGLE
	                               RET
DRAW_BARRIER2 ENDP

CHECK_BOUNDARY_BARRIER1 PROC NEAR

				
	                               MOV                 AX,X_BARRIER1
	                               CMP                 AX,SCREEN_MAX_X
	                               JE                  DONT_DRAW                     	;-> IF X==THE LAST ROW OF PIXELS THEN DONT DRAW
	                               MOV                 BX,SCREEN_MAX_X-LEN_BARRIER
	                               CMP                 BX,AX                         	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER LENGTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED

	                               JAE                 GOOD_LENGTH
	                               MOV                 LENMAX,SCREEN_MAX_X

	GOOD_LENGTH:                   
	                               MOV                 AX,Y_BARRIER1
	                               CMP                 AX,SCREEN_MAX_Y
	                               JE                  DONT_DRAW                     	;; IF Y== LAST COLUMN OF PIXELS THEN DONT DRAW
	                               MOV                 BX,SCREEN_MAX_Y-WID_BARRIER
	                               CMP                 BX,AX                         	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER WIDTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                               JAE                 GOOD_WIDTH

	                               MOV                 WIDMAX,SCREEN_MAX_Y

	GOOD_WIDTH:                    

	                               call                DRAW_BARRIER1

	DONT_DRAW:                     
	                               RET
CHECK_BOUNDARY_BARRIER1 ENDP




CHECK_BOUNDARY_BARRIER2 PROC NEAR

				
	                               MOV                 AX,X_BARRIER2
	                               CMP                 AX,SCREEN_MAX_X
	                               JGE                 DONT_DRAW2                    	;-> IF X>==THE LAST ROW OF PIXELS THEN DONT DRAW
	                               MOV                 BX,SCREEN_MAX_X-LEN_BARRIER
	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER LENGTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                               CMP                 BX,AX
	                               JAE                 GOOD_LENGTH2
	                               MOV                 LENMAX,SCREEN_MAX_X

	GOOD_LENGTH2:                  
	                               MOV                 AX,Y_BARRIER2
	                               CMP                 AX,SCREEN_MAX_Y
	                               JGE                 DONT_DRAW2                    	;; IF Y>== LAST COLUMN OF PIXELS THEN DONT DRAW
	                               MOV                 BX,SCREEN_MAX_Y-WID_BARRIER
	                               CMP                 BX,AX                         	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER WIDTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                               JAE                 GOOD_WIDTH2

	                               MOV                 WIDMAX,SCREEN_MAX_Y

	GOOD_WIDTH2:                   
	                               CALL                DRAW_BARRIER2
	                       

	DONT_DRAW2:                    
	                               RET
CHECK_BOUNDARY_BARRIER2 ENDP

CHECK_OVERLAPPING_BARRIER2 PROC NEAR

	                               MOV                 AX,X_BARRIER2
	                               CMP                 AX,X_BARRIER1
	                               JGE                 CHECK_LESS_X1               ; if x2>= x1 then go check if x2 is less than x1+its length
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER2
	CHECK_LESS_X1:                 
	                               MOV                 AX,X_BARRIER1
	                               ADD                 AX,LEN_BARRIER
	                               MOV                 BX,X_BARRIER2
	                               CMP                 BX,AX
	                               JLE                 X2_OVERLAPS                               ;this means it overlaps
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER2
	X2_OVERLAPS:  ;if barrier 2 overlaps with barrier 1,make barrier2 start at the end of barrier1                   
	                               MOV                 AX,X_BARRIER1
	                               ADD                 AX,LEN_BARRIER
	                               MOV                 X_BARRIER2,AX
	


	END_CHECK_OVERLAPPING_BARRIER2:
	                               CALL                CHECK_BOUNDARY_BARRIER2   ;call the functin which check that the barrier is in the screen

	                               RET
CHECK_OVERLAPPING_BARRIER2 ENDP


CHECK_OVERLAPPING_BARRIER1 PROC NEAR

	                               MOV                 AX,X_BARRIER1
	                               CMP                 AX,X_BARRIER2
	                               JGE                 CHECK_LESS_X2       ; if x1>= x2 then go check if x1 is less than x2+its length
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER1
	CHECK_LESS_X2:                 
	                               MOV                 AX,X_BARRIER2
	                               ADD                 AX,LEN_BARRIER
	                               MOV                 BX,X_BARRIER1
	                               CMP                 BX,AX
	                               JLE                 X1_OVERLAPS                   ;this means it overlaps
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER1
	X1_OVERLAPS: ;if barrier 1 overlaps with barrier 2,make barrier1 start at the end of barrier2                  
	                               MOV                 AX,X_BARRIER2
	                               ADD                 AX,LEN_BARRIER
	                               MOV                 X_BARRIER1,AX
	


	END_CHECK_OVERLAPPING_BARRIER1:
	                               CALL                CHECK_BOUNDARY_BARRIER1 ;call the functin which check that the barrier is in the screen

	                               RET
CHECK_OVERLAPPING_BARRIER1 ENDP


end main
