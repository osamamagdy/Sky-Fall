.model SMALL

.stack 64h

.data
	WINDOW_WIDTH DW 140h   ;the width of the window (320 pixels)
	WINDOW_HEIGHT DW 160  ;the height of the window (200 pixels)
	WINDOW_BOUNDS DW 6    ;variable used to check collisions early
	window_bounds_upper equ 15  
	TIME_AUX DB 0 ;variable used when checking if the time has changed
	
	 background_color EQU 53 ;pixel color id
    graphics_mode EQU 13h  ;320*200 pixels , 256colors

	PRE_POSTION_X   DW  ?
	PRE_POSITION_Y  DW ?

	first_player_X DW 50
	first_player_Y DW 50
	
	second_player_X DW 270
	SECOND_PLAYER_Y DW 50
	
	PLAYERS_WIDTH DW 20
	PLAYERS_HEIGHT DW 25
	PLAYERS_VELOCITY DW 04h
	
	    p1  DB 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 0, 0, 16, 39, 39, 39, 16, 0, 0, 0, 0, 16, 39, 39, 39, 16, 0, 0, 0 
        DB 0, 0, 0, 16, 16, 39, 39, 16, 0, 0, 0, 0, 16, 39, 39, 16, 16, 0, 0, 0, 0, 0, 0, 0, 16, 39, 14, 14, 16, 16, 16, 16, 14, 14, 39, 16, 0, 0, 0, 0
        DB 0, 0, 0, 31, 16, 14, 14, 39, 39, 39, 39, 39, 39, 14, 14, 16, 31, 0, 0, 0, 0, 0, 16, 16, 0, 16, 39, 39, 39, 39, 39, 39, 39, 39, 16, 0, 16, 16, 0, 0
        DB 0, 16, 39, 39, 16, 16, 39, 39, 39, 16, 16, 39, 39, 39, 16, 16, 39, 39, 16, 0, 0, 16, 39, 39, 14, 16, 39, 39, 16, 25, 25, 16, 39, 39, 16, 14, 39, 39, 16, 0
        DB 0, 0, 16, 14, 14, 16, 39, 16, 25, 25, 25, 25, 16, 39, 16, 14, 14, 16, 0, 0, 0, 0, 41, 16, 39, 16, 39, 16, 16, 16, 16, 16, 16, 39, 16, 39, 16, 41, 0, 0
        DB 0, 0, 41, 0, 16, 39, 16, 14, 14, 14, 14, 14, 14, 16, 39, 16, 0, 41, 0, 0, 0, 41, 41, 0, 0, 16, 14, 16, 16, 16, 16, 16, 16, 14, 16, 0, 0, 41, 41, 0
        DB 0, 41, 0, 0, 16, 39, 14, 14, 14, 14, 14, 14, 14, 14, 39, 16, 0, 0, 41, 0, 0, 41, 0, 16, 39, 39, 14, 14, 14, 14, 14, 14, 14, 14, 39, 39, 16, 0, 41, 0
        DB 41, 41, 16, 39, 14, 25, 25, 25, 16, 16, 16, 16, 25, 25, 25, 14, 39, 16, 41, 41, 41, 0, 16, 39, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 39, 16, 0, 41
        DB 41, 0, 16, 39, 16, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 16, 39, 16, 0, 41, 41, 0, 0, 16, 39, 14, 14, 14, 39, 39, 39, 39, 14, 14, 14, 39, 16, 0, 0, 41
        DB 41, 0, 0, 16, 39, 14, 14, 39, 39, 39, 39, 39, 39, 14, 14, 39, 16, 0, 0, 41, 41, 0, 0, 0, 16, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 16, 0, 0, 0, 41
        DB 41, 41, 41, 41, 41, 16, 16, 16, 39, 39, 39, 39, 16, 16, 16, 41, 41, 41, 41, 41, 41, 14, 14, 14, 14, 14, 14, 14, 16, 16, 16, 16, 14, 14, 14, 14, 14, 14, 14, 41
        DB 41, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 41, 41, 41, 41, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 41, 41, 41
        DB 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41

    p2  DB 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 0, 0, 16, 105, 105, 105, 16, 0, 0, 0, 0, 16, 105, 105, 105, 16, 0, 0, 0 
        DB 0, 0, 0, 16, 16, 105, 105, 16, 0, 0, 0, 0, 16, 105, 105, 16, 16, 0, 0, 0, 0, 0, 0, 0, 16, 105, 76, 76, 16, 16, 16, 16, 76, 76, 105, 16, 0, 0, 0, 0 
        DB 0, 0, 0, 31, 16, 76, 76, 105, 105, 105, 105, 105, 105, 76, 76, 16, 31, 0, 0, 0, 0, 0, 16, 16, 0, 16, 105, 105, 105, 105, 105, 105, 105, 105, 16, 0, 16, 16, 0, 0 
        DB 0, 16, 105, 105, 16, 16, 105, 105, 105, 16, 16, 105, 105, 105, 16, 16, 105, 105, 16, 0, 0, 16, 105, 105, 76, 16, 105, 105, 16, 25, 25, 16, 105, 105, 16, 76, 105, 105, 16, 0 
        DB 0, 0, 16, 76, 76, 16, 105, 16, 25, 25, 25, 25, 16, 105, 16, 76, 76, 16, 0, 0, 0, 0, 105, 16, 105, 16, 105, 16, 16, 16, 16, 16, 16, 105, 16, 105, 16, 105, 0, 0 
        DB 0, 0, 105, 0, 16, 105, 16, 76, 76, 76, 76, 76, 76, 16, 105, 16, 0, 105, 0, 0, 0, 105, 105, 0, 0, 16, 76, 16, 16, 16, 16, 16, 16, 76, 16, 0, 0, 105, 105, 0 
        DB 0, 105, 0, 0, 16, 105, 76, 76, 76, 76, 76, 76, 76, 76, 105, 16, 0, 0, 105, 0, 0, 105, 0, 16, 105, 105, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 16, 0, 105, 0
        DB 105, 105, 16, 105, 76, 25, 25, 25, 16, 16, 16, 16, 25, 25, 25, 76, 105, 16, 105, 105, 105, 0, 16, 105, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 105, 16, 0, 105
        DB 105, 0, 16, 105, 16, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 16, 105, 16, 0, 105, 105, 0, 0, 16, 105, 76, 76, 76, 105, 105, 105, 105, 76, 76, 76, 105, 16, 0, 0, 105
        DB 105, 0, 0, 16, 105, 76, 76, 105, 105, 105, 105, 105, 105, 76, 76, 105, 16, 0, 0, 105, 105, 0, 0, 0, 16, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 16, 0, 0, 0, 105
        DB 105, 105, 105, 105, 105, 16, 16, 16, 105, 105, 105, 105, 16, 16, 16, 105, 105, 105, 105, 105, 105, 76, 76, 76, 76, 76, 76, 76, 16, 16, 16, 16, 76, 76, 76, 76, 76, 76, 76, 105
        DB 105, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 105, 105, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 105
        DB 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105
.code
MAIN PROC FAR
    mov ax,@data
    mov ds ,ax

	CALL CLEAR_SCREEN
	 call draw_background	
		CHECK_TIME:
		
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			;if it's different, then draw, move, etc.
		
			MOV TIME_AUX,DL ;update time
		
           
			CALL draw_p1
			CALL draw_p2
			CALL MOVE_PLAYERS
			 
	
			JMP CHECK_TIME ;after everything checks time again
		
		RET
MAIN ENDP
	

	
	MOVE_PLAYERS PROC NEAR
		
		;check if any key is being pressed 
		MOV AH,01h
		INT 16h
		JZ CHECK_FIRST_PLAYER_MOVEMENT ;ZF = 1, JZ -> Jump If Zero
		
		;check which key is being pressed (AL = ASCII character)
		MOV AH,00h
		INT 16h
		CHECK_FIRST_PLAYER_MOVEMENT:
		
		;STORE THE PREVIOUS POSITION OF PLAYER 1 3LSHAN NB2A N7TO LW 3MLT COLLISION
		MOV BX,first_player_X
		MOV PRE_POSTION_X,BX
		mov BX,first_player_Y
		MOV PRE_POSITION_Y,BX
		;if it is 'w' or 'W' move up
		CMP AL,77h ;'w'
		JE MOVE_FIRST_PLAYER_UP
		CMP AL,57h ;'W'
		JE MOVE_FIRST_PLAYER_UP
		
		;if it is 's' or 'S' move down
		CMP AL,73h ;'s'
		JE MOVE_FIRST_PLAYER_DOWN
		CMP AL,53h ;'S'
		JE MOVE_FIRST_PLAYER_DOWN
		
		
        ;if it is 'D' or 'd' move first player right
        cmp AL,44h
        je MOVE_FIRST_PLAYER_right
        cmp al,64h
        je MOVE_FIRST_PLAYER_right

      ; if it is 'A' or 'a' move first player left
        cmp AL,41h
        je MOVE_FIRST_PLAYER_LEFT
        cmp al,61h
        je MOVE_FIRST_PLAYER_LEFT

        JMP CHECK_SECOND_PLAYER_MOVEMENT

		MOVE_FIRST_PLAYER_UP:
			MOV AX,PLAYERS_VELOCITY
			SUB first_player_Y,AX
			
			MOV AX,window_bounds_upper
			CMP first_player_Y,AX
			JL FIX_FIRST_PLAYER_TOP_POSITION
			JMP CHECK_FOR_COLLISION_1
			FIX_FIRST_PLAYER_TOP_POSITION: ;LW 5RG BRA EL BOUNDARIES BA7TO FY WINDOW_BOUNDS
				MOV first_player_Y,AX
				JMP CHECK_FOR_COLLISION_1
			
		MOVE_FIRST_PLAYER_DOWN:
			MOV AX,PLAYERS_VELOCITY
			ADD first_player_Y,AX
			MOV AX,WINDOW_HEIGHT
			SUB AX,WINDOW_BOUNDS
			SUB AX,PLAYERS_HEIGHT
			CMP first_player_Y,AX
			JG FIX_FIRST_PLAYER_BOTTOM_POSITION
			JMP CHECK_FOR_COLLISION_1
			FIX_FIRST_PLAYER_BOTTOM_POSITION:    ;LW 5RG BRA EL BOUNDARIES BA7TO FY WINDOW_BOUNDS
				MOV first_player_Y,AX
				JMP CHECK_FOR_COLLISION_1
		
        MOVE_FIRST_PLAYER_right:
        	MOV AX,PLAYERS_VELOCITY
            ADD first_player_X,AX
            MOV AX,WINDOW_WIDTH
            SUB AX,PLAYERS_WIDTH
            SUB AX,WINDOW_BOUNDS
            cmp first_player_X,AX
            JG  FIX_FIRST_PLAYER_RIGHT_POSITION
            JMP CHECK_FOR_COLLISION_1
            FIX_FIRST_PLAYER_RIGHT_POSITION:   ;LW 5RG BRA EL BOUNDARIES BA7TO FY WINDOW_BOUNDS
                MOV first_player_X,AX
				JMP CHECK_FOR_COLLISION_1

        MOVE_FIRST_PLAYER_LEFT:
            mov ax,PLAYERS_VELOCITY
            SUB first_player_X,ax
			jo FIX_FIRST_PLAYER_LEFT_POSITION  ;CHECK OVER FLOW MALHASH LAZMHA BAB2A ASHELHA BOKRA
			MOV AX,WINDOW_BOUNDS
			CMP first_player_X,AX
			JL FIX_FIRST_PLAYER_LEFT_POSITION
			JMP CHECK_FOR_COLLISION_1
			FIX_FIRST_PLAYER_LEFT_POSITION:
				MOV first_player_X,AX
				JMP CHECK_FOR_COLLISION_1
       
	    CHECK_FOR_COLLISION_1:
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		MOV AX,first_player_X      ;IF maxx1 > minx2
		ADD AX,PLAYERS_WIDTH
		CMP AX,second_player_X
		JNG CHECK_SECOND_PLAYER_MOVEMENT   ;MA3MLSH COLLISION
		
		MOV AX,second_player_X    ;IF minx1 < maxx2
		ADD AX,PLAYERS_WIDTH
		CMP first_player_X,AX
		JNL CHECK_SECOND_PLAYER_MOVEMENT      ;MA3MLSH COLLISION
		
		MOV AX,SECOND_PLAYER_Y       ;IF maxy1 > miny2 
		ADD AX,PLAYERS_HEIGHT
		CMP AX,first_player_Y
		JNG CHECK_SECOND_PLAYER_MOVEMENT       ;MA3MLSH COLLISION
		
		MOV AX,first_player_Y            ;IF  miny1 < maxy2  
		ADD AX,PLAYERS_HEIGHT
		CMP SECOND_PLAYER_Y,AX
		JNL CHECK_SECOND_PLAYER_MOVEMENT       ;MA3MLSH COLLISION

		MOV DX,PRE_POSTION_X      ; LW EDA MN KOL DOL MN 8ER M JUMP L  CHECK_SECOND_PLAYER_MOVEMENT YB2A KDA 7SL COLLISION W A7T FEH EL
		MOV first_player_X,DX     ; THE VALUES EL 2DEMA
		MOV DX,PRE_POSITION_Y
		MOV first_player_Y,DX

				
		;second player movement
		CHECK_SECOND_PLAYER_MOVEMENT:

        mov DX,second_player_X
        MOV PRE_POSTION_X,DX
        mov DX,SECOND_PLAYER_Y
        MOV PRE_POSITION_Y,DX

			;if it is 'o' or 'O' move up
		IN AX, 60H      
	    CMP AL, 48H     
	    JE MOVE_SECOND_PLAYER_UP
	    CMP AL, 50H     
	    JE MOVE_SECOND_PLAYER_DOWN
	    CMP AL, 4BH     
	    JE MOVE_SECOND_PLAYER_left
	    CMP AL, 4DH     
	    JE MOVE_SECOND_PLAYER_right	

			JMP EXIT_PLAYERS_MOVEMENT
			

			MOVE_SECOND_PLAYER_UP:
				MOV AX,PLAYERS_VELOCITY
				SUB SECOND_PLAYER_Y,AX
				
				MOV AX,window_bounds_upper
				CMP SECOND_PLAYER_Y,AX
				JL FIX_second_player_TOP_POSITION
				JMP CHECK_FOR_COLLISION_2
				
				FIX_second_player_TOP_POSITION:
					MOV SECOND_PLAYER_Y,AX
					JMP CHECK_FOR_COLLISION_2
			
			MOVE_SECOND_PLAYER_DOWN:
				MOV AX,PLAYERS_VELOCITY
				ADD SECOND_PLAYER_Y,AX
				MOV AX,WINDOW_HEIGHT
				SUB AX,WINDOW_BOUNDS
				SUB AX,PLAYERS_HEIGHT
				CMP SECOND_PLAYER_Y,AX
				JG FIX_second_player_down_POSITION
				JMP CHECK_FOR_COLLISION_2
				
				FIX_second_player_down_POSITION:
					MOV SECOND_PLAYER_Y,AX
					JMP CHECK_FOR_COLLISION_2


            MOVE_SECOND_PLAYER_left:
				MOV AX,PLAYERS_VELOCITY
				SUB second_player_X,AX
				MOV AX,WINDOW_BOUNDS
				CMP second_player_X,AX
				JL FIX_SECOND_PLAYER_left_POSITION
				JMP CHECK_FOR_COLLISION_2
				
				FIX_SECOND_PLAYER_left_POSITION:
					MOV second_player_X,AX
					JMP CHECK_FOR_COLLISION_2

            MOVE_SECOND_PLAYER_right:
                MOV AX,PLAYERS_VELOCITY
                ADD second_player_X,AX
                MOV AX,WINDOW_WIDTH
                SUB AX,WINDOW_BOUNDS
                sub AX,PLAYERS_WIDTH
                CMP second_player_X,AX
                JG FIX_SECOND_PLAYER_RIGHT_POSITION
                JMP CHECK_FOR_COLLISION_2
                FIX_SECOND_PLAYER_RIGHT_POSITION:
                    MOV second_player_X,AX
					JMP CHECK_FOR_COLLISION_2


        CHECK_FOR_COLLISION_2:
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		MOV AX,first_player_X      ;IF maxx1 > minx2
		ADD AX,PLAYERS_WIDTH
		CMP AX,second_player_X
		JNG EXIT_PLAYERS_MOVEMENT   ;MA3MLSH COLLISION
		
		MOV AX,second_player_X    ;IF minx1 < maxx2
		ADD AX,PLAYERS_WIDTH
		CMP first_player_X,AX
		JNL EXIT_PLAYERS_MOVEMENT      ;MA3MLSH COLLISION
		
		MOV AX,SECOND_PLAYER_Y       ;IF maxy1 > miny2 
		ADD AX,PLAYERS_HEIGHT
		CMP AX,first_player_Y
		JNG EXIT_PLAYERS_MOVEMENT       ;MA3MLSH COLLISION
		
		MOV AX,first_player_Y            ;IF  miny1 < maxy2  
		ADD AX,PLAYERS_HEIGHT
		CMP SECOND_PLAYER_Y,AX
		JNL EXIT_PLAYERS_MOVEMENT       ;MA3MLSH COLLISION

		MOV DX,PRE_POSTION_X      ; LW EDA MN KOL DOL MN 8ER M JUMP L  CHECK_SECOND_PLAYER_MOVEMENT YB2A KDA 7SL COLLISION W A7T FEH EL
		MOV second_player_X,DX     ; THE VALUES EL 2DEMA
		MOV DX,PRE_POSITION_Y
		MOV SECOND_PLAYER_Y,DX


		EXIT_PLAYERS_MOVEMENT:
		
			RET
		
	MOVE_PLAYERS ENDP
	
	
	CLEAR_SCREEN PROC NEAR
			MOV AH,00h ;set the configuration to video mode
			MOV AL,13h ;choose the video mode
			INT 10h    ;execute the configuration 
		
			MOV AH,0fh ;set the configuration
			MOV BH,00h ;to the background color
			MOV BL,00h ;choose black as background color
			INT 10h    ;execute the configuration
			
			RET
	CLEAR_SCREEN ENDP

	draw_p1 proc
;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov di,0
    mov al,p1[DI] ;the pixel color
    mov bh,0  ;the page number
    mov cx,first_player_X  ;the starting x-position (column)
    add cx,PLAYERS_WIDTH ;as we draw in the reversed order
    mov dx,first_player_Y ;the starting y-position (row)
    add dx,PLAYERS_HEIGHT  ;as we draw in the reversed order
    ;here we loop for the image size (player_size)
    fill_p1:
        cmp al,0
        jz pass_the_pixel
        int 10h
        pass_the_pixel:
        inc di
        mov al,p1[DI]
        dec cx
        cmp cx,first_player_X
        jnz fill_p1 ;if not zero so we continue to the same row 
        mov cx,first_player_X  ;the starting x-position (column)
        add cx,PLAYERS_WIDTH ;as we draw in the reversed order
        dec dx ;if not zero so we continue to draw the background
        cmp dx,first_player_Y
        jnz fill_p1
    ;;;;;;;;;;;;;;
	ret	
	draw_p1 endp


draw_p2 proc
;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov di,0
    mov al,p2[DI] ;the pixel color
    mov bh,0  ;the page number
    mov cx,second_player_X  ;the starting x-position (column)
    add cx,PLAYERS_WIDTH ;as we draw in the reversed order
    mov dx,SECOND_PLAYER_Y ;the starting y-position (row)
    add dx,PLAYERS_HEIGHT  ;as we draw in the reversed order
    ;here we loop for the image size (player_size)
    fill_p2:
        cmp al,0
        jz pass_the_pixel_2
        int 10h
        pass_the_pixel_2:
        inc di
        mov al,p2[DI]
        dec cx
        cmp cx,second_player_X
        jnz fill_p2 ;if not zero so we continue to the same row 
        mov cx,second_player_X  ;the starting x-position (column)
        add cx,PLAYERS_WIDTH ;as we draw in the reversed order
        dec dx ;if not zero so we continue to draw the background
        cmp dx,SECOND_PLAYER_Y
        jnz fill_p2
    ;;;;;;;;;;;;;;
ret
draw_p2 endp

;fill the whole screen with the background color
draw_background proc

;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov al,background_color ;the pixel color
    mov bh,0  ;the page number
    mov cx,0  ;the x-position (column)
    mov dx,0  ;the y-position (row)
    ;here we loop for 4/5 of the screen
    fillblue:
        int 10h
        inc cx
        cmp cx,WINDOW_WIDTH
        jnz fillblue ;if not zero so we continue to the same row 
        inc dx
        mov cx,0 
        cmp dx,WINDOW_HEIGHT ;if not zero so we continue to draw the background
        jnz fillblue
    ;;;;;;;;;;;;;;
ret
draw_background endp

END MAIN