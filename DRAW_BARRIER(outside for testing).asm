MACRO_DRAW_BARRIER1 MACRO x,y         		;x,y are the postion of the upper left vertex
    MOV X_BARRIER1,x
    MOV Y_BARRIER1,y 
    call DRAW_BARRIER1

ENDM 

MACRO_DRAW_BARRIER2 MACRO x,y         		;x,y are the postion of the upper left vertex
    MOV X_BARRIER2,x
    MOV Y_BARRIER2,y 
    call DRAW_BARRIER2

ENDM 



.model small    ; Code and Data max 64K
.stack 100h     ; Only 256 bytes of stack
.data         		; Start giving some data...
LEN    DW 100d
WID    DW 100d
LENMAX DW 252d
X_BARRIER1 DW 0
Y_BARRIER1 DW 0

X_BARRIER2 DW 0
Y_BARRIER2 DW 0
	
WIDMAX DW 152d
.code                                        		; Start writing code...

main proc far

	              mov                ax, @DATA
	              mov                ds,ax
   
	              MOV                AH,0
	              MOV                AL,04H
	              INT                10H
 
	              CALL               CLEAR_SCREEN
                  	                     

	             ; MACRO_DRAW_BARRIER1 20D,30D
                  MACRO_DRAW_BARRIER2 200D,0D







	FOREVER:      
	              JMP                FOREVER


	              mov                AH,4ch
	              int                21h


main endp

DRAWRECTANGLE proc

	              PUSH               LEN
	PRINTL:       
	              MOV                AH,0CH      	;draw pixel int
	              MOV                AL,7H       	;color wanted
	              MOV                BH,0H       	;page1
	              MOV                CX,LEN      	;x pos
	              MOV                DX,wid      	;y pos
	              INT                10H
	              INC                LEN
	              MOV                BX,LENMAX
	              CMP                LEN,BX
	              JNZ                PRINTL


	              POP                LEN

	              PUSH               WID
	PRINTW:       
	              MOV                AH,0CH
	              MOV                AL,7H
	              MOV                BH,0H
    
	              MOV                CX,LEN
	              MOV                DX,WID
	              INT                10H
	              INC                WID
	              MOV                BX,WIDMAX
	              INC                BX
	              CMP                WID,BX
	              JNZ                PRINTW
   
	              POP                WID
	              PUSH               LEN

    
	PRINTL2:      
	              MOV                AH,0CH
	              MOV                AL,7H
	              MOV                BH,0H
    
	              MOV                CX,LEN
	              MOV                DX,WIDMAX
	              INT                10H
	              INC                LEN
	              MOV                BX,LENMAX
	              CMP                LEN,BX
	              JNZ                PRINTL2

	              POP                LEN

	              PUSH               WID

	              
	PRINTW2:      
	              MOV                AH,0CH
	              MOV                AL,7H
	              MOV                BH,0H
    
	              MOV                CX,LENMAX
	              MOV                DX,WID
	              INT                10H
	              INC                WID
	              MOV                BX,WIDMAX
	              INC                BX
	              CMP                WID,BX
	              JNZ                PRINTW2
	              POP                WID


	              RET
DRAWRECTANGLE ENDP

FILLRECTANGLE proc
	              PUSH               LEN
	FILL:         
	              PUSH               WID
	FILLINNER:    


	              MOV                AH,0CH
	              MOV                AL,7H
	              MOV                BH,0H
    
	              MOV                CX,LEN
	              MOV                DX,WID
	              INT                10H

	              MOV                BX,WIDMAX
	              INC                WID
	              CMP                WID,BX
	              JNZ                FILLINNER
	              POP                WID

	              INC                LEN
	              MOV                BX,LENMAX
	              CMP                LEN,BX
	              JNZ                FILL

	              POP                LEN
	              RET
FILLRECTANGLE ENDP


CLEAR_SCREEN PROC NEAR
	              MOV                AH,00h      	;set the configuration to video mode
	              MOV                AL,13h      	;choose the video mode 320x200
	              INT                10h         	;execute the configuration
		
	              MOV                AH,0fh      	;set the configuration
	              MOV                BH,00h      	;to the background color
	              MOV                BL,00h      	;choose black as background color
	              INT                10h         	;execute the configuration
			
	              RET
CLEAR_SCREEN ENDP

DRAW_BARRIER1 PROC NEAR
                	   mov  Ax,X_BARRIER1
	                   mov  LEN,Ax
	                   add  Ax,150d
	                   mov  LENMAX,ax
	                   mov  ax,Y_BARRIER1
	                   mov  WID,ax
	                   add  ax,50d
	                   mov  WIDMAX,ax
	                   CALL DRAWRECTANGLE
	                   CALL FILLRECTANGLE
                       RET
DRAW_BARRIER1 endp

DRAW_BARRIER2 PROC NEAR
                	   mov  Ax,X_BARRIER2
	                   mov  LEN,Ax
	                   add  Ax,150d
	                   mov  LENMAX,ax
	                   mov  ax,Y_BARRIER2
	                   mov  WID,ax
	                   add  ax,50d
	                   mov  WIDMAX,ax
	                   CALL DRAWRECTANGLE
	                   CALL FILLRECTANGLE
                       RET
DRAW_BARRIER2 endp
end main
