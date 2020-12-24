.model SMALL

.stack 64h

.data
	WINDOW_WIDTH DW 140h   ;the width of the window (320 pixels)
	WINDOW_HEIGHT DW 0C8h  ;the height of the window (200 pixels)
	WINDOW_BOUNDS DW 6     ;variable used to check collisions early
	
	TIME_AUX DB 0 ;variable used when checking if the time has changed
	

	PRE_POSTION_X   DW  ?
	PRE_POSITION_Y  DW ?
	first_player_X DW 0Ah
	first_player_Y DW 0Ah
	
	second_player_X DW 110h
	SECOND_PLAYER_Y DW 0Ah
	
	PLAYERS_WIDTH DW 20
	PLAYERS_HEIGHT DW 25
	PLAYERS_VELOCITY DW 04h
.code
MAIN PROC FAR
    mov ax,@data
    mov ds ,ax
  CALL CLEAR_SCREEN
		
		CHECK_TIME:
		
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			;if it's different, then draw, move, etc.
			
			MOV TIME_AUX,DL ;update time
			
			CALL CLEAR_SCREEN
			
			CALL MOVE_PLAYERS
			CALL DRAW_PLAYERS
			
			JMP CHECK_TIME ;after everything checks time again
		
		RET
MAIN ENDP
	

	
	MOVE_PLAYERS PROC NEAR
		
		;left paddle movement
		
		;check if any key is being pressed (if not check the other paddle)
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
			
			MOV AX,WINDOW_BOUNDS
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

			;if it is 'o' or 'O' move up
			CMP AL,49h ;'o'
			JE MOVE_SECOND_PLAYER_UP
			CMP AL,69h ;'O'
			JE MOVE_SECOND_PLAYER_UP
			
			;if it is 'K' or 'k' move down
			CMP AL,6Bh ;'K'
			JE MOVE_SECOND_PLAYER_DOWN
			CMP AL,4Bh ;'K'
			JE MOVE_SECOND_PLAYER_DOWN
		
			
            ;if it is 'J' or 'j' move lefft
			CMP AL,4Ah ;'J'
			JE MOVE_SECOND_PLAYER_left
			CMP AL,6Ah ;'j'
			JE MOVE_SECOND_PLAYER_left

            ;if it is 'L' or 'l' move right
			CMP AL,4Ch ;'J'
			JE MOVE_SECOND_PLAYER_right
			CMP AL,6Ch ;'j'
			JE MOVE_SECOND_PLAYER_right

			JMP EXIT_PLAYERS_MOVEMENT
			

			MOVE_SECOND_PLAYER_UP:
				MOV AX,PLAYERS_VELOCITY
				SUB SECOND_PLAYER_Y,AX
				
				MOV AX,WINDOW_BOUNDS
				CMP SECOND_PLAYER_Y,AX
				JL FIX_second_player_TOP_POSITION
				JMP EXIT_PLAYERS_MOVEMENT
				
				FIX_second_player_TOP_POSITION:
					MOV SECOND_PLAYER_Y,AX
					JMP EXIT_PLAYERS_MOVEMENT
			
			MOVE_SECOND_PLAYER_DOWN:
				MOV AX,PLAYERS_VELOCITY
				ADD SECOND_PLAYER_Y,AX
				MOV AX,WINDOW_HEIGHT
				SUB AX,WINDOW_BOUNDS
				SUB AX,PLAYERS_HEIGHT
				CMP SECOND_PLAYER_Y,AX
				JG FIX_second_player_down_POSITION
				JMP EXIT_PLAYERS_MOVEMENT
				
				FIX_second_player_down_POSITION:
					MOV SECOND_PLAYER_Y,AX
					JMP EXIT_PLAYERS_MOVEMENT


            MOVE_SECOND_PLAYER_left:
				MOV AX,PLAYERS_VELOCITY
				SUB second_player_X,AX
				MOV AX,WINDOW_BOUNDS
				CMP second_player_X,AX
				JL FIX_SECOND_PLAYER_left_POSITION
				JMP EXIT_PLAYERS_MOVEMENT
				
				FIX_SECOND_PLAYER_left_POSITION:
					MOV second_player_X,AX
					JMP EXIT_PLAYERS_MOVEMENT

            MOVE_SECOND_PLAYER_right:
                MOV AX,PLAYERS_VELOCITY
                ADD second_player_X,AX
                MOV AX,WINDOW_WIDTH
                SUB AX,WINDOW_BOUNDS
                sub AX,PLAYERS_WIDTH
                CMP second_player_X,AX
                JG FIX_SECOND_PLAYER_RIGHT_POSITION
                JMP EXIT_PLAYERS_MOVEMENT
                FIX_SECOND_PLAYER_RIGHT_POSITION:
                    MOV second_player_X,AX
					JMP EXIT_PLAYERS_MOVEMENT


		EXIT_PLAYERS_MOVEMENT:
		
			RET
		
	MOVE_PLAYERS ENDP
	
	
	
	
	
	DRAW_PLAYERS PROC NEAR
		
		MOV CX,first_player_X ;set the initial column (X)
		MOV DX,first_player_Y ;set the initial line (Y)
		
		DRAW_FIRST_PLAYER_HORIZONTAL:
			MOV AH,0Ch ;set the configuration to writing a pixel
			MOV AL,0Ah ;choose white as color
			MOV BH,00h ;set the page number 
			INT 10h    ;execute the configuration
			
			INC CX     ;CX = CX + 1
			MOV AX,CX          ;CX - first_player_X > PLAYERS_WIDTH (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,first_player_X
			CMP AX,PLAYERS_WIDTH
			JNG DRAW_FIRST_PLAYER_HORIZONTAL
			
			MOV CX,first_player_X ;the CX register goes back to the initial column
			INC DX        ;we advance one line
			
			MOV AX,DX              ;DX - first_player_Y > PLAYERS_HEIGHT (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,first_player_Y
			CMP AX,PLAYERS_HEIGHT
			JNG DRAW_FIRST_PLAYER_HORIZONTAL
			
			
		MOV CX,second_player_X ;set the initial column (X)
		MOV DX,SECOND_PLAYER_Y ;set the initial line (Y)
		
		DRAW_SECOND_PLAYER_HORIZONTAL:
			MOV AH,0Ch ;set the configuration to writing a pixel
			MOV AL,0Fh ;choose white as color
			MOV BH,00h ;set the page number 
			INT 10h    ;execute the configuration
			
			INC CX     ;CX = CX + 1
			MOV AX,CX          ;CX - second_player_X > PLAYERS_WIDTH (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,second_player_X
			CMP AX,PLAYERS_WIDTH
			JNG DRAW_SECOND_PLAYER_HORIZONTAL
			
			MOV CX,second_player_X ;the CX register goes back to the initial column
			INC DX        ;we advance one line
			
			MOV AX,DX              ;DX - SECOND_PLAYER_Y > PLAYERS_HEIGHT (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,SECOND_PLAYER_Y
			CMP AX,PLAYERS_HEIGHT
			JNG DRAW_SECOND_PLAYER_HORIZONTAL
			
		RET
	DRAW_PLAYERS ENDP
	
	CLEAR_SCREEN PROC NEAR
			MOV AH,00h ;set the configuration to video mode
			MOV AL,13h ;choose the video mode
			INT 10h    ;execute the configuration 
		
			MOV AH,0Bh ;set the configuration
			MOV BH,00h ;to the background color
			MOV BL,00h ;choose black as background color
			INT 10h    ;execute the configuration
			
			RET
	CLEAR_SCREEN ENDP


END MAIN