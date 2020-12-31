MACRO_CLEAR_PLAYER MACRO X,Y

						mov pre_position_x,x
						mov pre_position_y,y
						call Update_Players
ENDM

; MACRO_CLEAR_Barrier MACRO X,Y

; 						mov pre_position_x,x
; 						mov pre_position_y,y
; 						call Update_Players
; ENDM



.model small

.stack 64h

.data
	WINDOW_WIDTH        equ 320                              ;the width of the Game window (320 pixels)
	WINDOW_HEIGHT       equ 160                              ;the height of the Game window (200*4/5 pixels)---> the chat takes 1/5 of the console
	WINDOW_BOUNDS       equ 6                                ; used to check collisions early from the lower,left,right pounds
	window_bounds_upper equ 15								 ;height of the health bar
	health_bar_width    equ 100                              ;width of each player's health bar
	heart_height        equ 10                               ;height of the heart image in health bar
	heart_width         equ 15                               ;height of the heart image in health bar
	TIME_AUX            DB  0                                ;variable used when checking if the time has changed
	
	background_color    EQU 53                               ;Background pixel color id
	graphics_mode       EQU 13h                              ;320*200 pixels , 256colors

	PRE_POSITION_X       DW  0								 ;Temp variable used when moving position to check first if it causes collisions
	PRE_POSITION_Y      DW  0								 ;Temp variable used when moving position to check first if it causes collisions
	PRE_POSITION_X2       DW  0								 ;Temp variable used when moving position to check first if it causes collisions
	PRE_POSITION_Y2      DW  0								 ;Temp variable used when moving position to check first if it causes collisions

	first_player_X      DW  50								 ;The starting X-position of player one
	first_player_Y      DW  50								 ;The starting Y-position of player one
	first_player_health DW  5                                 ;Number of hearts to the first player
	first_player_health_X equ 0								 ;the starting upper left x coordinate of the first player's first heart
	first_player_health_Y equ 0								 ;the starting upper left y coordinate of the first player's first heart
	
	second_player_X     DW  270								 ;The starting X-position of player two
	SECOND_PLAYER_Y     DW  50								 ;The starting Y-position of player two
	second_player_health DW 5                                ;Number of hearts to the second player
    second_player_health_X equ 305							 ;the starting upper left x coordinate of the second player's first heart
	second_player_health_Y equ 0							 ;the starting upper left y coordinate of the second player's first heart
	
	PLAYERS_WIDTH       equ  20								 ;the width of player's image
	PLAYERS_HEIGHT      equ  25								 ;the height of player's image
	PLAYERS_VELOCITY    DW  04h

	;VARIABLES USED IN THE PROCS OF DRAWING THE BARRIER
	LEN       	 DW  100d									 ;used by the draw barrier proc
	WID          DW  100d									 ;used by the draw barrier proc
	LENMAX       DW  252d									 ;used by the draw barrier proc
	WIDMAX       DW  152d									 ;used by the draw barrier proc
	Initial_Y_Barrier1   EQU 124
	Initial_Y_Barrier2 EQU 124
	X_BARRIER1   DW  10									 	 ; xpos of barrier1
	Y_BARRIER1   DW  124  									 ; ypos of barrier1

	X_BARRIER2   DW  260 									 ; xpos of barrier2
	Y_BARRIER2   DW  104									 ; ypos of barrier2


	
	;using in moving barriers as after each cycle (in which the barrier goes from the bottom of the page to the top of it)
	; X_BARRIER1_Last_value DW 10
	; X_BARRIER2_Last_value DW 260
	; Y_BARRIER1_Last_value DW 124
	; Y_BARRIER2_Last_value DW 104




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;#DEFINES FOR THE LENGTH AND SIZE OF THE BARRIER
	BARRIER_HORIZONTAL_SIZE  EQU 60D
	BARRIER_VERTICAL_SIZE  EQU 10D
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;SCREEN SIZE IN PIXELS
	SCREEN_MAX_X EQU 319D
	SCREEN_MAX_Y EQU 199D




	;next is the first player's pixel colors/Note: they are indexed in reversed order (from the (20,25) to (0,0))
	p1                  DB  0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 0, 0, 16, 39, 39, 39, 16, 0, 0, 0, 0, 16, 39, 39, 39, 16, 0, 0, 0
	                    DB  0, 0, 0, 16, 16, 39, 39, 16, 0, 0, 0, 0, 16, 39, 39, 16, 16, 0, 0, 0, 0, 0, 0, 0, 16, 39, 14, 14, 16, 16, 16, 16, 14, 14, 39, 16, 0, 0, 0, 0
	                    DB  0, 0, 0, 31, 16, 14, 14, 39, 39, 39, 39, 39, 39, 14, 14, 16, 31, 0, 0, 0, 0, 0, 16, 16, 0, 16, 39, 39, 39, 39, 39, 39, 39, 39, 16, 0, 16, 16, 0, 0
	                    DB  0, 16, 39, 39, 16, 16, 39, 39, 39, 16, 16, 39, 39, 39, 16, 16, 39, 39, 16, 0, 0, 16, 39, 39, 14, 16, 39, 39, 16, 25, 25, 16, 39, 39, 16, 14, 39, 39, 16, 0
	                    DB  0, 0, 16, 14, 14, 16, 39, 16, 25, 25, 25, 25, 16, 39, 16, 14, 14, 16, 0, 0, 0, 0, 41, 16, 39, 16, 39, 16, 16, 16, 16, 16, 16, 39, 16, 39, 16, 41, 0, 0
	                    DB  0, 0, 41, 0, 16, 39, 16, 14, 14, 14, 14, 14, 14, 16, 39, 16, 0, 41, 0, 0, 0, 41, 41, 0, 0, 16, 14, 16, 16, 16, 16, 16, 16, 14, 16, 0, 0, 41, 41, 0
	                    DB  0, 41, 0, 0, 16, 39, 14, 14, 14, 14, 14, 14, 14, 14, 39, 16, 0, 0, 41, 0, 0, 41, 0, 16, 39, 39, 14, 14, 14, 14, 14, 14, 14, 14, 39, 39, 16, 0, 41, 0
	                    DB  41, 41, 16, 39, 14, 25, 25, 25, 16, 16, 16, 16, 25, 25, 25, 14, 39, 16, 41, 41, 41, 0, 16, 39, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 39, 16, 0, 41
	                    DB  41, 0, 16, 39, 16, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 16, 39, 16, 0, 41, 41, 0, 0, 16, 39, 14, 14, 14, 39, 39, 39, 39, 14, 14, 14, 39, 16, 0, 0, 41
	                    DB  41, 0, 0, 16, 39, 14, 14, 39, 39, 39, 39, 39, 39, 14, 14, 39, 16, 0, 0, 41, 41, 0, 0, 0, 16, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 16, 0, 0, 0, 41
	                    DB  41, 41, 41, 41, 41, 16, 16, 16, 39, 39, 39, 39, 16, 16, 16, 41, 41, 41, 41, 41, 41, 14, 14, 14, 14, 14, 14, 14, 16, 16, 16, 16, 14, 14, 14, 14, 14, 14, 14, 41
	                    DB  41, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 41, 41, 41, 41, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 41, 41, 41
	                    DB  41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41






	;next is the first player's heart pixel colors/Note: they are indexed in reversed order'
	h1 				   DB 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 39, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 39, 39, 39, 16 
 					   DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 39, 39, 39, 39, 39, 16, 0, 0, 0, 0, 0, 0, 0, 16, 39, 39, 39, 39, 39, 39, 39, 16, 0, 0, 0, 0, 0, 16, 39, 39 
 					   DB 39, 39, 39, 39, 39, 39, 39, 16, 0, 0, 0, 0, 16, 39, 39, 39, 39, 16, 39, 39, 39, 39, 16, 0, 0, 0, 0, 0, 16, 39, 39, 16, 0, 16, 39, 39, 16, 0, 0, 0 
 					   DB 0, 0, 0, 0, 16, 16, 0, 0, 0, 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 	;next is the Second player's pixel colors/Note: they are indexed in reversed order (from the (20,25) to (0,0))
	p2                  DB  0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 16, 16, 16, 16, 16, 0, 0, 0, 0, 0, 0, 16, 105, 105, 105, 16, 0, 0, 0, 0, 16, 105, 105, 105, 16, 0, 0, 0
	                    DB  0, 0, 0, 16, 16, 105, 105, 16, 0, 0, 0, 0, 16, 105, 105, 16, 16, 0, 0, 0, 0, 0, 0, 0, 16, 105, 76, 76, 16, 16, 16, 16, 76, 76, 105, 16, 0, 0, 0, 0
	                    DB  0, 0, 0, 31, 16, 76, 76, 105, 105, 105, 105, 105, 105, 76, 76, 16, 31, 0, 0, 0, 0, 0, 16, 16, 0, 16, 105, 105, 105, 105, 105, 105, 105, 105, 16, 0, 16, 16, 0, 0
	                    DB  0, 16, 105, 105, 16, 16, 105, 105, 105, 16, 16, 105, 105, 105, 16, 16, 105, 105, 16, 0, 0, 16, 105, 105, 76, 16, 105, 105, 16, 25, 25, 16, 105, 105, 16, 76, 105, 105, 16, 0
	                    DB  0, 0, 16, 76, 76, 16, 105, 16, 25, 25, 25, 25, 16, 105, 16, 76, 76, 16, 0, 0, 0, 0, 105, 16, 105, 16, 105, 16, 16, 16, 16, 16, 16, 105, 16, 105, 16, 105, 0, 0
	                    DB  0, 0, 105, 0, 16, 105, 16, 76, 76, 76, 76, 76, 76, 16, 105, 16, 0, 105, 0, 0, 0, 105, 105, 0, 0, 16, 76, 16, 16, 16, 16, 16, 16, 76, 16, 0, 0, 105, 105, 0
	                    DB  0, 105, 0, 0, 16, 105, 76, 76, 76, 76, 76, 76, 76, 76, 105, 16, 0, 0, 105, 0, 0, 105, 0, 16, 105, 105, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 16, 0, 105, 0
	                    DB  105, 105, 16, 105, 76, 25, 25, 25, 16, 16, 16, 16, 25, 25, 25, 76, 105, 16, 105, 105, 105, 0, 16, 105, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 105, 16, 0, 105
	                    DB  105, 0, 16, 105, 16, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 16, 105, 16, 0, 105, 105, 0, 0, 16, 105, 76, 76, 76, 105, 105, 105, 105, 76, 76, 76, 105, 16, 0, 0, 105
	                    DB  105, 0, 0, 16, 105, 76, 76, 105, 105, 105, 105, 105, 105, 76, 76, 105, 16, 0, 0, 105, 105, 0, 0, 0, 16, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 16, 0, 0, 0, 105
	                    DB  105, 105, 105, 105, 105, 16, 16, 16, 105, 105, 105, 105, 16, 16, 16, 105, 105, 105, 105, 105, 105, 76, 76, 76, 76, 76, 76, 76, 16, 16, 16, 16, 76, 76, 76, 76, 76, 76, 76, 105
	                    DB  105, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 105, 105, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 76, 105, 105, 105
        				DB 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105, 105


	;next is the second player's heart pixel colors/Note: they are indexed in reversed order'
	h2 					DB 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 105, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 105, 105, 105, 16 
 						DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 105, 105, 105, 105, 105, 16, 0, 0, 0, 0, 0, 0, 0, 16, 105, 105, 105, 105, 105, 105, 105, 16, 0, 0, 0, 0, 0, 16, 105, 105 
 						DB 105, 105, 105, 105, 105, 105, 105, 16, 0, 0, 0, 0, 16, 105, 105, 105, 105, 16, 105, 105, 105, 105, 16, 0, 0, 0, 0, 0, 16, 105, 105, 16, 0, 16, 105, 105, 16, 0, 0, 0 
 						DB 0, 0, 0, 0, 16, 16, 0, 0, 0, 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0




	Barrier_array	 	DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 					    DB 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 16, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
 						DB 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186
 						DB 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 16, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186, 186 



.code
MAIN PROC FAR
	                                 mov  ax,@data
	                                 mov  ds ,ax

	                                CALL FAR PTR CLEAR_SCREEN ;clear the screen before entering the game
	                                call FAR PTR draw_background ;draw the background of the Game window
									call FAR PTR draw_h1
									call FAR PTR draw_h2
									CALL FAR PTR draw_p1
									CALL FAR PTR draw_p2
									call FAR PTR DRAW_BARRIER1
									call FAR PTR DRAW_BARRIER2

									;;;;;;;;;;;;;Game Loop functions
									CHECK_TIME:       

												MOV  AH,2Ch                          	;get the system time
												INT  21h                             	;CH = hour CL = minute DH = second DL = 1/100 seconds
												CMP  DL,TIME_AUX                     	;is the current time equal to the previous one(TIME_AUX)?
												JE   CHECK_TIME                      	;if it is the same, check again
												;if it's different, then draw, move, etc.
												MOV  TIME_AUX,DL                     	;update time
												CALL FAR PTR MOVE_BARRIERS
												;check if health is zero, Game Over
												mov ax,first_player_health
												cmp ax,0
												jz Game_Over

												;check if health is zero, Game Over
												mov ax,second_player_health
												cmp ax,0
												jz Game_Over

												CALL FAR PTR MOVE_PLAYERS
												;;;;;;;;;;;;;Flushing the keyboard buffer
												mov ah,0ch
												mov al,0
												int 21h												
	                                 JMP  CHECK_TIME                      	;after everything checks time again		
	                                 
									Game_Over: 
	                                CALL FAR PTR CLEAR_SCREEN ;clear the screen before entering the game

									 
									 RET
MAIN ENDP
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;taking the character from the user and reacting to it
MOVE_PLAYERS PROC FAR
		
	;check if any key is being pressed
	                                 MOV  AH,01h
	                                 INT  16h
	                                 JnZ   CHECK_MOVEMENT     	;ZF = 1, JZ -> Jump If Zero
									RET
	CHECK_MOVEMENT:     
	;Read which key is being pressed (AL = ASCII character)
	                                 MOV  AH,00h
	                                 INT  16h

									cmp AH , 40h ;check if it is the second player( Scan Code in AH, if greater than 40h --> it must be second player)
									JG Second_MOVED
									call FAR PTR CHECK_FIRST_PLAYER_MOVEMENT
									RET

									Second_MOVED:
									call FAR PTR CHECK_SECOND_PLAYER_MOVEMENT
									RET	
				
	;second player movement
MOVE_PLAYERS ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;clear the console
CLEAR_SCREEN PROC FAR
	                                 MOV  AH,00h                          	;set the configuration to video mode
	                                 MOV  AL,13h                          	;choose the video mode
	                                 INT  10h                             	;execute the configuration
		
	                                 MOV  AH,0fh                          	;set the configuration
	                                 MOV  BH,00h                          	;to the background color
	                                 MOV  BL,00h                          	;choose black as background color
	                                 INT  10h                             	;execute the configuration
			
	                                 RET
CLEAR_SCREEN ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;draw the image of player one
draw_p1 proc FAR
	;;;;;;;;;;;;;;
	                                 mov  ah,0ch                          	;this means with int 10h ---> you're drawing a pixel
	                                 mov  di,0
	                                 mov  al,p1[DI]                       	;the pixel color
	                                 mov  bh,0                            	;the page number
	                                 mov  cx,first_player_X               	;the starting x-position (column)
	                                 add  cx,PLAYERS_WIDTH                	;as we draw in the reversed order
	                                 mov  dx,first_player_Y               	;the starting y-position (row)
	                                 add  dx,PLAYERS_HEIGHT               	;as we draw in the reversed order
	;here we loop for the image size (player_size)
	fill_p1:                         
	                                 cmp  al,0
	                                 jz   pass_the_pixel
	                                 int  10h
	pass_the_pixel:                  
	                                 inc  di
	                                 mov  al,p1[DI]
	                                 dec  cx
	                                 cmp  cx,first_player_X
	                                 jnz  fill_p1                         	;if not zero so we continue to the same row
	                                 mov  cx,first_player_X               	;the starting x-position (column)
	                                 add  cx,PLAYERS_WIDTH                	;as we draw in the reversed order
	                                 dec  dx                              	;if not zero so we continue to draw the background
	                                 cmp  dx,first_player_Y
	                                 jnz  fill_p1
	;;;;;;;;;;;;;;
	                                 ret
draw_p1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;draw the image of player two
draw_p2 proc FAR
	;;;;;;;;;;;;;;
	                                 mov  ah,0ch                          	;this means with int 10h ---> you're drawing a pixel
	                                 mov  di,0
	                                 mov  al,p2[DI]                       	;the pixel color
	                                 mov  bh,0                            	;the page number
	                                 mov  cx,second_player_X              	;the starting x-position (column)
	                                 add  cx,PLAYERS_WIDTH                	;as we draw in the reversed order
	                                 mov  dx,SECOND_PLAYER_Y              	;the starting y-position (row)
	                                 add  dx,PLAYERS_HEIGHT               	;as we draw in the reversed order
	;here we loop for the image size (player_size)
	fill_p2:                         
	                                 cmp  al,0
	                                 jz   pass_the_pixel_2
	                                 int  10h
	pass_the_pixel_2:                
	                                 inc  di
	                                 mov  al,p2[DI]
	                                 dec  cx
	                                 cmp  cx,second_player_X
	                                 jnz  fill_p2                         	;if not zero so we continue to the same row
	                                 mov  cx,second_player_X              	;the starting x-position (column)
	                                 add  cx,PLAYERS_WIDTH                	;as we draw in the reversed order
	                                 dec  dx                              	;if not zero so we continue to draw the background
	                                 cmp  dx,SECOND_PLAYER_Y
	                                 jnz  fill_p2
	;;;;;;;;;;;;;;
	                                 ret
draw_p2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;fill the whole screen with the background color
draw_background proc FAR

	;;;;;;;;;;;;;;
	                                 mov  ah,0ch                          	;this means with int 10h ---> you're drawing a pixel
	                                 mov  al,background_color             	;the pixel color
	                                 mov  bh,0                            	;the page number
	                                 mov  cx,0                            	;the x-position (column)
	                                 mov  dx,0                            	;the y-position (row)
	;here we loop for 4/5 of the screen
	fillblue:                        
	                                 int  10h
	                                 inc  cx
	                                 cmp  cx,WINDOW_WIDTH
	                                 jnz  fillblue                        	;if not zero so we continue to the same row
	                                 inc  dx
	                                 mov  cx,0
	                                 cmp  dx,WINDOW_HEIGHT                	;if not zero so we continue to draw the background
	                                 jnz  fillblue
	;;;;;;;;;;;;;;
	                                 ret
draw_background endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;draw a number of hearts that is first_player_health
draw_h1 PROC FAR

	;check if health is zero, don't draw
	mov ax,first_player_health
	cmp ax,0
	jnz first_player_alive

	RET
	first_player_alive:
    mov  ah,0ch                          	;this means with int 10h ---> you're drawing a pixel
	mov PRE_POSITION_X,first_player_health_X
	mov PRE_POSITION_Y,first_player_health_Y
	mov si,0
	CLEAR_H1:
											mov al,background_color
											mov bh,0
											mov cx,PRE_POSITION_X              	;the starting x-position (column)
											add cx,health_bar_width             
											mov dx,pre_position_y
											add dx,window_bounds_upper
											
											fill_h1_background:
											int  10h
											dec cx
											cmp cx,pre_position_x 
											jnz fill_h1_background
											mov cx,PRE_POSITION_X              	;the starting x-position (column)
											add cx,health_bar_width             
											dec dx
											cmp dx,PRE_POSITION_Y
											jnz fill_h1_background
	draw_one_Red_heart:
			;;;;;;;;;;;;;;
											mov  di,0
											mov  al,h1[DI]                       	;the pixel color
											mov  bh,0                            	;the page number
											mov  cx,PRE_POSITION_X          ;the starting x-position (column)
											add  cx,heart_WIDTH                	;as we draw in the reversed order
											mov  dx,PRE_POSITION_Y          ;the starting y-position (row)
											add  dx,heart_HEIGHT               	;as we draw in the reversed order
			;here we loop for the image size (player_size)
			fill_h1:                         
											cmp  al,0
											jz   pass_the_pixel__1
											int  10h
			pass_the_pixel__1:                
											inc  di
											mov  al,h1[DI]
											dec  cx
											cmp  cx,PRE_POSITION_X
											jnz  fill_h1                         	;if not zero so we continue to the same row
											mov  cx,PRE_POSITION_X              	;the starting x-position (column)
											add  cx,heart_WIDTH                	;as we draw in the reversed order
											dec  dx                              	;if not zero so we continue to draw the background
											cmp  dx,PRE_POSITION_Y
											jnz  fill_h1
			;;;;;;;;;;;;;;
	inc si 
	cmp si,first_player_health
	jz finish_drawing_h1
	mov di,pre_position_x
	add di,heart_WIDTH
	mov pre_position_x,di

	jmp draw_one_Red_heart
	finish_drawing_h1:	
	ret

draw_h1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

;draw a number of hearts that is second_player_health
draw_h2 PROC FAR
	;check if health is zero, don't draw
	mov ax,second_player_health
	cmp AX,0
	jnz second_player_alive
	RET

	second_player_alive:
    mov  ah,0ch                          	;this means with int 10h ---> you're drawing a pixel
	mov PRE_POSITION_X,second_player_health_X
	mov PRE_POSITION_Y,second_player_health_Y
	mov si,0
	CLEAR_H2:
											mov al,background_color
											mov bh,0
											mov cx,WINDOW_WIDTH              	;the ending x-position (column)
											SUB cx,health_bar_width             
											mov dx,pre_position_y
											add dx,window_bounds_upper
											
											fill_h2_background:
											int  10h
											INC cx
											cmp cx,WINDOW_WIDTH 
											jnz fill_h2_background
											mov cx,WINDOW_WIDTH              	;the starting x-position (column)
											sub cx,health_bar_width             
											dec dx
											cmp dx,PRE_POSITION_Y
											jnz fill_h2_background

	draw_one_Blue_heart:
			;;;;;;;;;;;;;;
											mov  di,0
											mov  al,h2[DI]                       	;the pixel color
											mov  bh,0                            	;the page number
											mov  cx,PRE_POSITION_X          ;the starting x-position (column)
											add  cx,heart_WIDTH                	;as we draw in the reversed order
											mov  dx,PRE_POSITION_Y          ;the starting y-position (row)
											add  dx,heart_HEIGHT               	;as we draw in the reversed order
			;here we loop for the image size (player_size)
			fill_h2:                         
											cmp  al,0
											jz   pass_the_pixel__2
											int  10h
			pass_the_pixel__2:                
											inc  di
											mov  al,h2[DI]
											dec  cx
											cmp  cx,PRE_POSITION_X
											jnz  fill_h2                         	;if not zero so we continue to the same row
											mov  cx,PRE_POSITION_X              	;the starting x-position (column)
											add  cx,heart_WIDTH                	;as we draw in the reversed order
											dec  dx                              	;if not zero so we continue to draw the background
											cmp  dx,PRE_POSITION_Y
											jnz  fill_h2
			;;;;;;;;;;;;;;
	inc si 
	cmp si,second_player_health
	jz finish_drawing_h2
	mov di,pre_position_x
	sub di,heart_WIDTH
	mov pre_position_x,di

	jmp draw_one_Blue_heart
	finish_drawing_h2:	
	ret

draw_h2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FILLRECTANGLE proc FAR

                            MOV DI,0
	                        PUSH                LEN
	FILL:                   
	                        PUSH                LEN
	FILLINNER:              


	                        MOV                 AH,0CH
	                        MOV                 AL,Barrier_array[DI]
							INC                 DI
	                        MOV                 BH,0H
    
	                        MOV                 CX,LEN
	                        MOV                 DX,WID
	                        INT                 10H

	                        MOV                 BX,LENMAX
	                        INC                 LEN
	                        CMP                 BX,LEN
	                        JNZ                 FILLINNER
	                        POP                 LEN

	                        INC                 WID
	                        MOV                 BX,WIDMAX
	                        CMP                 BX,WID
	                        JNZ                 FILL

	                        POP                 WID
	                        RET
FILLRECTANGLE ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DRAW_BARRIER1 PROC FAR
;As we use pre_position variables as temp, and we always call draw_barrier after we update their values 
;We need to condition only one special case is when we draw them for the first time
mov ax,pre_position_y
cmp ax,0
jz first_time_to_draw1

							CLEAR_B1: 
										    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
											mov al,background_color
											mov bh,0
											mov cx,PRE_POSITION_X              	;the starting x-position (column)
											add cx, BARRIER_HORIZONTAL_SIZE             
											mov dx,pre_position_y
											add dx, BARRIER_VERTICAL_SIZE
											
											fill_b1_background:
											int  10h
											dec cx
											cmp cx,pre_position_x 
											jnz fill_b1_background
											mov cx,PRE_POSITION_X              	;the starting x-position (column)
											add cx, BARRIER_HORIZONTAL_SIZE             
											dec dx
											cmp dx,PRE_POSITION_Y
											jnz fill_b1_background


							first_time_to_draw1:

	                        mov                 Ax,X_BARRIER1
	                        mov                 LEN,Ax
	                        add                 Ax, BARRIER_HORIZONTAL_SIZE
	                        mov                 LENMAX,ax
	                        mov                 ax,Y_BARRIER1
	                        mov                 WID,ax
	                        add                 ax, BARRIER_VERTICAL_SIZE
	                        mov                 WIDMAX,ax
	              

	                        CALL  FAR PTR              CHECK_BOUNDARY_BARRIER1
	                        RET
DRAW_BARRIER1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAW_BARRIER2 PROC FAR

;As we use pre_position variables as temp, and we always call draw_barrier after we update their values 
;We need to condition only one special case is when we draw them for the first time
mov ax,pre_position_y
cmp ax,0
jz first_draw2

							CLEAR_B2: 
											mov ah,0ch                          	;this means with int 10h ---> you're drawing a pixel'
											mov al,background_color
											mov bh,0
											mov cx,PRE_POSITION_X2              	;the starting x-position (column)
											add cx, BARRIER_HORIZONTAL_SIZE             
											mov dx,pre_position_y2
											add dx, BARRIER_VERTICAL_SIZE
											
											fill_b2_background:
											int  10h
											dec cx
											cmp cx,pre_position_x2 
											jnz fill_b2_background
											mov cx,PRE_POSITION_X2              	;the starting x-position (column)
											add cx, BARRIER_HORIZONTAL_SIZE             
											dec dx
											cmp dx,PRE_POSITION_Y2
											jnz fill_b2_background


							first_draw2:

                           ;; CALL                CHECK_OVERLAPPING_BARRIER2
	                        mov                 Ax,X_BARRIER2
	                        mov                 LEN,Ax
	                        add                 Ax, BARRIER_HORIZONTAL_SIZE
	                        mov                 LENMAX,ax
	                        mov                 ax,Y_BARRIER2
	                        mov                 WID,ax
	                        add                 ax, BARRIER_VERTICAL_SIZE
	                        mov                 WIDMAX,ax
	             
	                        CALL  FAR PTR              CHECK_BOUNDARY_BARRIER2

	                        RET
DRAW_BARRIER2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;checking that this move is allowed 
CHECK_FIRST_PLAYER_MOVEMENT PROC FAR
;STORE THE PREVIOUS POSITION OF PLAYER 1, we will use it if the new position causes collision (the same as push it in the stack)
	                                 MOV  BX,first_player_X
	                                 MOV  PRE_POSITION_X,BX
	                                 mov  BX,first_player_Y
	                                 MOV  PRE_POSITION_Y,BX
	;if it is 'w' or 'W' move up
	                                 CMP  AL,77h                          	;'w'
	                                 JE   MOVE_FIRST_PLAYER_UP
	                                 CMP  AL,57h                          	;'W'
	                                 JE   MOVE_FIRST_PLAYER_UP
		
	;if it is 's' or 'S' move down
	                                 CMP  AL,73h                          	;'s'
	                                 JE   MOVE_FIRST_PLAYER_DOWN
	                                 CMP  AL,53h                          	;'S'
	                                 JE   MOVE_FIRST_PLAYER_DOWN
		
		
	;if it is 'D' or 'd' move first player right
	                                 cmp  AL,44h
	                                 je   MOVE_FIRST_PLAYER_right
	                                 cmp  al,64h
	                                 je   MOVE_FIRST_PLAYER_right

	; if it is 'A' or 'a' move first player left
	                                 cmp  AL,41h
	                                 je   MOVE_FIRST_PLAYER_LEFT
	                                 cmp  al,61h
	                                 je   MOVE_FIRST_PLAYER_LEFT
	MOVE_FIRST_PLAYER_UP:            
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 SUB  first_player_Y,AX
			
	                                 MOV  AX,window_bounds_upper
	                                 CMP  first_player_Y,AX
	                                 JL   FIX_FIRST_PLAYER_TOP_POSITION     ;it will jump if first_player_Y < AX ---> outside the window
	                                 JMP  CHECK_FOR_COLLISION_1
	FIX_FIRST_PLAYER_TOP_POSITION:                                        	;Return it to inside the window 
	                                 MOV  first_player_Y,AX
	                                 JMP  CHECK_FOR_COLLISION_1
			
	MOVE_FIRST_PLAYER_DOWN:          
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 ADD  first_player_Y,AX
	                                 MOV  AX,WINDOW_HEIGHT
	                                 SUB  AX,WINDOW_BOUNDS
	                                 SUB  AX,PLAYERS_HEIGHT
	                                 CMP  first_player_Y,AX
	                                 JG   FIX_FIRST_PLAYER_BOTTOM_POSITION ;it will jump if first_player_Y > AX---> outside the window
	                                 JMP  CHECK_FOR_COLLISION_1
	FIX_FIRST_PLAYER_BOTTOM_POSITION:                                     	;Return it to inside the window
	                                 MOV  first_player_Y,AX
	                                 JMP  CHECK_FOR_COLLISION_1
		
	MOVE_FIRST_PLAYER_right:         
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 ADD  first_player_X,AX
	                                 MOV  AX,WINDOW_WIDTH
	                                 SUB  AX,PLAYERS_WIDTH
	                                 SUB  AX,WINDOW_BOUNDS
	                                 cmp  first_player_X,AX
	                                 JG   FIX_FIRST_PLAYER_RIGHT_POSITION  ;it will jump if first_player_X > AX---> outside the window
	                                 JMP  CHECK_FOR_COLLISION_1
	FIX_FIRST_PLAYER_RIGHT_POSITION:                                      	;Return it to inside the window
	                                 MOV  first_player_X,AX
	                                 JMP  CHECK_FOR_COLLISION_1

	MOVE_FIRST_PLAYER_LEFT:          
	                                 mov  ax,PLAYERS_VELOCITY
	                                 SUB  first_player_X,ax
	                                 MOV  AX,WINDOW_BOUNDS
	                                 CMP  first_player_X,AX
	                                 JL   FIX_FIRST_PLAYER_LEFT_POSITION
	                                 JMP  CHECK_FOR_COLLISION_1
	FIX_FIRST_PLAYER_LEFT_POSITION:  
	                                 MOV  first_player_X,AX
	                                 JMP  CHECK_FOR_COLLISION_1
       
	CHECK_FOR_COLLISION_1:           
	; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
	                                 MOV  AX,first_player_X               	;IF maxx1 > minx2
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,second_player_X
	                                 JNG  Exit_FIRST_PLAYER_MOVEMENT           	;No collision will happen
		
	                                 MOV  AX,second_player_X              	;IF minx1 < maxx2
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  first_player_X,AX
	                                 JNL  Exit_FIRST_PLAYER_MOVEMENT           	;No collision will happen


	                                 MOV  AX,SECOND_PLAYER_Y              	;IF maxy1 > miny2
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,first_player_Y
	                                 JNG  Exit_FIRST_PLAYER_MOVEMENT           	;No collision will happen
		
	                                 MOV  AX,first_player_Y               	;IF  miny1 < maxy2
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  SECOND_PLAYER_Y,AX
	                                 JNL  Exit_FIRST_PLAYER_MOVEMENT           	;No collision will happen

	                                 MOV  DX,PRE_POSITION_X                	; If it reached here then there will be a collision
	                                 MOV  first_player_X,DX               	; Return the old values
	                                 MOV  DX,PRE_POSITION_Y
	                                 MOV  first_player_Y,DX
									 RET
	Exit_FIRST_PLAYER_MOVEMENT:
									call FAR PTR Update_Players
									call FAR PTR draw_p1
	
	RET
CHECK_FIRST_PLAYER_MOVEMENT ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;checking that this move is allowed 
CHECK_SECOND_PLAYER_MOVEMENT PROC  FAR
	                                 mov  DX,second_player_X
	                                 MOV  PRE_POSITION_X,DX
	                                 mov  DX,SECOND_PLAYER_Y
	                                 MOV  PRE_POSITION_Y,DX

	;if it is 'o' or 'O' move up
	                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IN   AX, 60H
	                                 CMP  AH, 48H
	                                 JE   MOVE_SECOND_PLAYER_UP
	                                 CMP  AH, 50H
	                                 JE   MOVE_SECOND_PLAYER_DOWN
	                                 CMP  AH, 4BH
	                                 JE   MOVE_SECOND_PLAYER_left
	                                 CMP  AH, 4DH
	                                 JE   MOVE_SECOND_PLAYER_right

	                                 JMP  EXIT_PLAYERS_MOVEMENT
			

	MOVE_SECOND_PLAYER_UP:           
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 SUB  SECOND_PLAYER_Y,AX
				
	                                 MOV  AX,window_bounds_upper
	                                 CMP  SECOND_PLAYER_Y,AX
	                                 JL   FIX_second_player_TOP_POSITION
	                                 JMP  CHECK_FOR_COLLISION_2
				
	FIX_second_player_TOP_POSITION:  
	                                 MOV  SECOND_PLAYER_Y,AX
	                                 JMP  CHECK_FOR_COLLISION_2
			
	MOVE_SECOND_PLAYER_DOWN:         
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 ADD  SECOND_PLAYER_Y,AX
	                                 MOV  AX,WINDOW_HEIGHT
	                                 SUB  AX,WINDOW_BOUNDS
	                                 SUB  AX,PLAYERS_HEIGHT
	                                 CMP  SECOND_PLAYER_Y,AX
	                                 JG   FIX_second_player_down_POSITION
	                                 JMP  CHECK_FOR_COLLISION_2
				
	FIX_second_player_down_POSITION: 
	                                 MOV  SECOND_PLAYER_Y,AX
	                                 JMP  CHECK_FOR_COLLISION_2


	MOVE_SECOND_PLAYER_left:         
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 SUB  second_player_X,AX
	                                 MOV  AX,WINDOW_BOUNDS
	                                 CMP  second_player_X,AX
	                                 JL   FIX_SECOND_PLAYER_left_POSITION
	                                 JMP  CHECK_FOR_COLLISION_2
				
	FIX_SECOND_PLAYER_left_POSITION: 
	                                 MOV  second_player_X,AX
	                                 JMP  CHECK_FOR_COLLISION_2

	MOVE_SECOND_PLAYER_right:        
	                                 MOV  AX,PLAYERS_VELOCITY
	                                 ADD  second_player_X,AX
	                                 MOV  AX,WINDOW_WIDTH
	                                 SUB  AX,WINDOW_BOUNDS
	                                 sub  AX,PLAYERS_WIDTH
	                                 CMP  second_player_X,AX
	                                 JG   FIX_SECOND_PLAYER_RIGHT_POSITION
	                                 JMP  CHECK_FOR_COLLISION_2
	FIX_SECOND_PLAYER_RIGHT_POSITION:
	                                 MOV  second_player_X,AX
	                                 JMP  CHECK_FOR_COLLISION_2


	CHECK_FOR_COLLISION_2:           
	; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
	                                 MOV  AX,first_player_X               	;IF maxx1 > minx2
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,second_player_X
	                                 JNG  EXIT_PLAYERS_MOVEMENT           	;No collision will happen
		
	                                 MOV  AX,second_player_X              	;IF minx1 < maxx2
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  first_player_X,AX
	                                 JNL  EXIT_PLAYERS_MOVEMENT           	;No collision will happen
		
	                                 MOV  AX,SECOND_PLAYER_Y              	;IF maxy1 > miny2
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,first_player_Y
	                                 JNG  EXIT_PLAYERS_MOVEMENT           	;No collision will happen
		
	                                 MOV  AX,first_player_Y               	;IF  miny1 < maxy2
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  SECOND_PLAYER_Y,AX
	                                 JNL  EXIT_PLAYERS_MOVEMENT           	;No collision will happen

	                                 MOV  DX,PRE_POSITION_X                	; If it reached here then there will be a collision
	                                 MOV  second_player_X,DX              	; Return the old values
	                                 MOV  DX,PRE_POSITION_Y
	                                 MOV  SECOND_PLAYER_Y,DX
									 RET

	EXIT_PLAYERS_MOVEMENT:
									Call FAR PTR Update_Players
									Call FAR PTR draw_p2


	RET
CHECK_SECOND_PLAYER_MOVEMENT ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;erase the player original position before moving
Update_Players PROC FAR
	
;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov al,background_color ;the pixel color
    mov bh,0  ;the page number
	MOV CX,PRE_POSITION_X
    MOV SI,CX
    ADD SI,PLAYERS_WIDTH
    ADD SI,1
	MOV Dx,PRE_POSITION_Y
    MOV DI,DX
    ADD DI,PLAYERS_HEIGHT
    ADD DI,1
    ;here we loop for 4/5 of the screen
    fillblue1:
        int 10h
        inc cx
        cmp cx,SI
        jnz fillblue1 ;if not zero so we continue to the same row 
        inc dx
        mov cx,PRE_POSITION_X
        cmp dx,DI ;if not zero so we continue to draw the background
        jnz fillblue1
    ;;;;;;;;;;;;;;

	RET
Update_Players ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


first_player_barriers_coli PROC FAR
                    ;check for collision between player1 and barriers(1,2)
      ;CHECK_FOR_COLLISION_p1_b1:          
	                           ;first_player_x+players_width<x_barrier1
	                                 MOV  AX,first_player_X               	
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,X_BARRIER1
	                                 JNG   CHECK_FOR_COLLISION_p1_b2            	;No collision will happen
		;first_player_x>x_barrier1+ BARRIER_HORIZONTAL_SIZE
	                                 MOV  AX,X_BARRIER1               	
	                                 ADD  AX, BARRIER_HORIZONTAL_SIZE
	                                 CMP  first_player_X,AX
	                                 JNL   CHECK_FOR_COLLISION_p1_b2         	;No collision will happen
		                           ;first_player_Y+players_HEIGHT<Y_barrier1
	                                 MOV  AX,First_PLAYER_Y              
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,Y_BARRIER1
	                                 JNG  CHECK_FOR_COLLISION_p1_b2           	;No collision will happen
		
	                         ;first_player_Y>Y_barrier1+ BARRIER_VERTICAL_SIZE
	                                 MOV  AX,Y_BARRIER1              
	                                 ADD  AX, BARRIER_VERTICAL_SIZE
	                                 CMP  first_player_Y,AX
	                                 JNL   CHECK_FOR_COLLISION_p1_b2         	;No collision will happen

							 ;clearing the player and moving him down								
									mov ax,first_player_x
									mov bx,first_player_Y
									MACRO_CLEAR_PLAYER ax,bx
                                    ADD first_player_Y,PLAYERS_HEIGHT
                                    ADD first_player_Y,BARRIER_VERTICAL_SIZE
									
							  ;check if this makes him out of the game window make it at the top again								
									mov bx,first_player_y
									add bx,players_HEIGHT
									cmp bx,WINDOW_HEIGHT

									JLE  first_player_position_is_ok1

									mov bx,20
									mov first_player_Y,bx
									first_player_position_is_ok1:
							  ;draw the player in the new position and decrease health
									CALL FAR PTR draw_p1
									;DEC first_player_health

								
									CALL draw_h1

CHECK_FOR_COLLISION_p1_b2:          
	                           ;first_player_x+players_width<x_barrier2
	                                 MOV  AX,first_player_X               	
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,X_BARRIER2
	                                 JNG     EXIT_PLAYERS_barriers_col           	;No collision will happen
		;first_player_x>x_barrier2+ BARRIER_HORIZONTAL_SIZE
	                                 MOV  AX,X_BARRIER2               	
	                                 ADD  AX, BARRIER_HORIZONTAL_SIZE
	                                 CMP  first_player_X,AX
	                                 JNL      EXIT_PLAYERS_barriers_col      	;No collision will happen
		                           ;first_player_Y+players_HEIGHT<Y_barrier2
	                                 MOV  AX,First_PLAYER_Y              
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,Y_BARRIER2
	                                 JNG    EXIT_PLAYERS_barriers_col        	;No collision will happen
		
	                         ;first_player_Y>Y_barrier2+ BARRIER_VERTICAL_SIZE
	                                 MOV  AX,Y_BARRIER2              
	                                 ADD  AX, BARRIER_VERTICAL_SIZE
	                                 CMP  first_player_Y,AX
	                                 JNL      EXIT_PLAYERS_barriers_col         	;No collision will happen

							 ;clearing the player and moving him down								
									mov ax,first_player_x
									mov bx,first_player_Y
									MACRO_CLEAR_PLAYER ax,bx
                                    ADD first_player_Y,PLAYERS_HEIGHT
                                    ADD first_player_Y,BARRIER_VERTICAL_SIZE
									
							  ;check if this makes him out of the game window make it at the top again								
									mov bx,first_player_y
									add bx,players_HEIGHT
									cmp bx,WINDOW_HEIGHT

									JLE  first_player_position_is_ok2

									mov bx,20
									mov first_player_Y,bx
									first_player_position_is_ok2:
							  ;draw the player in the new position and decrease health
									CALL FAR PTR draw_p1
									;DEC first_player_health

								
									CALL draw_h1

   EXIT_PLAYERS_barriers_col:  
	                                 RET
first_player_barriers_coli ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

second_player_barriers_coli PROC FAR
                    ;;check for collision between player2 and barriers(1,2)


 CHECK_FOR_COLLISION_p2_b1:          
	                           ;second_player_x+players_width<x_barrier1
	                                 MOV  AX,second_player_X               	
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,X_BARRIER1
	                                 JNG   CHECK_FOR_COLLISION_p2_b2            	;No collision will happen
		;second_player_x>x_barrier1+ BARRIER_HORIZONTAL_SIZE
	                                 MOV  AX,X_BARRIER1               	
	                                 ADD  AX, BARRIER_HORIZONTAL_SIZE
	                                 CMP  second_player_X,AX
	                                 JNL   CHECK_FOR_COLLISION_p2_b2         	;No collision will happen
		                           ;second_player_Y+players_HEIGHT<Y_barrier1
	                                 MOV  AX,second_PLAYER_Y              
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,Y_BARRIER1
	                                 JNG  CHECK_FOR_COLLISION_p2_b2          	;No collision will happen
		
	                         ;second_player_Y>Y_barrier1+ BARRIER_VERTICAL_SIZE
	                                 MOV  AX,Y_BARRIER1              
	                                 ADD  AX, BARRIER_VERTICAL_SIZE
	                                 CMP  second_player_Y,AX
	                                 JNL  CHECK_FOR_COLLISION_p2_b2         	;No collision will happen

							 ;clearing the player and moving him down								
									mov ax,second_player_x
									mov bx,second_player_Y
									MACRO_CLEAR_PLAYER ax,bx
                                    ADD second_player_Y,PLAYERS_HEIGHT
                                    ADD second_player_Y,BARRIER_VERTICAL_SIZE
									
							  ;check if this makes him out of the game window make it at the top again								
									mov bx,second_player_y
									add bx,players_HEIGHT
									cmp bx,WINDOW_HEIGHT

									JLE  second_player_position_is_ok1

									mov bx,20
									mov second_player_Y,bx
									second_player_position_is_ok1:
							  ;draw the player in the new position and decrease health
									CALL FAR PTR draw_p2
									;DEC second_player_health

								
									CALL draw_h2

 CHECK_FOR_COLLISION_p2_b2:          
	                           ;second_player_x+players_width<x_barrier2
	                                 MOV  AX,second_player_X               	
	                                 ADD  AX,PLAYERS_WIDTH
	                                 CMP  AX,X_BARRIER2
	                                 JNG    EXIT2_PLAYERS_barriers_col          	;No collision will happen
		;second_player_x>x_barrier1+ BARRIER_HORIZONTAL_SIZE
	                                 MOV  AX,X_BARRIER2               	
	                                 ADD  AX, BARRIER_HORIZONTAL_SIZE
	                                 CMP  second_player_X,AX
	                                 JNL     EXIT2_PLAYERS_barriers_col         	;No collision will happen
		                           ;second_player_Y+players_HEIGHT<Y_barrier1
	                                 MOV  AX,second_PLAYER_Y              
	                                 ADD  AX,PLAYERS_HEIGHT
	                                 CMP  AX,Y_BARRIER2
	                                 JNG    EXIT2_PLAYERS_barriers_col         	;No collision will happen
		
	                         ;second_player_Y>Y_barrier1+ BARRIER_VERTICAL_SIZE
	                                 MOV  AX,Y_BARRIER2              
	                                 ADD  AX, BARRIER_VERTICAL_SIZE
	                                 CMP  second_player_Y,AX
	                                 JNL    EXIT2_PLAYERS_barriers_col        	;No collision will happen

							 ;clearing the player and moving him down								
									mov ax,second_player_x
									mov bx,second_player_Y
									MACRO_CLEAR_PLAYER ax,bx
                                    ADD second_player_Y,PLAYERS_HEIGHT
                                    ADD second_player_Y,BARRIER_VERTICAL_SIZE
									
							  ;check if this makes him out of the game window make it at the top again								
									mov bx,second_player_y
									add bx,players_HEIGHT
									cmp bx,WINDOW_HEIGHT

									JLE  second_player_position_is_ok2

									;the initial start of the player
									mov bx,20
									mov second_player_Y,bx
									second_player_position_is_ok2:
							  ;draw the player in the new position and decrease health
									CALL FAR PTR draw_p2
									;DEC second_player_health

								
									CALL draw_h2
   
  EXIT2_PLAYERS_barriers_col:  
	                                 RET
second_player_barriers_coli ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECK_BOUNDARY_BARRIER1 PROC FAR

				
	                        MOV                 AX,X_BARRIER1
	                        CMP                 AX,SCREEN_MAX_X
	                        JE                  DONT_DRAW                  	;-> IF X==THE LAST ROW OF PIXELS THEN DONT DRAW
	                        MOV                 BX,SCREEN_MAX_X- BARRIER_HORIZONTAL_SIZE
	                        CMP                 BX,AX                      	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER LENGTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED

	                        JAE                 GOOD_LENGTH
	                        MOV                 LENMAX,SCREEN_MAX_X

	GOOD_LENGTH:            
	                        MOV                 AX,Y_BARRIER1
	                        CMP                 AX,SCREEN_MAX_Y
	                        JE                  DONT_DRAW                  	;; IF Y== LAST COLUMN OF PIXELS THEN DONT DRAW
	                        MOV                 BX,SCREEN_MAX_Y- BARRIER_VERTICAL_SIZE
	                        CMP                 BX,AX                      	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER WIDTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                        JAE                 GOOD_WIDTH

	                        MOV                 WIDMAX,SCREEN_MAX_Y

	GOOD_WIDTH:             
	                                        
	                        CALL                FILLRECTANGLE

	DONT_DRAW:              
	                        RET
CHECK_BOUNDARY_BARRIER1 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



CHECK_BOUNDARY_BARRIER2 PROC FAR

				
	                        MOV                 AX,X_BARRIER2
	                        CMP                 AX,SCREEN_MAX_X
	                        JE                  DONT_DRAW2                  	;-> IF X==THE LAST ROW OF PIXELS THEN DONT DRAW
	                        MOV                 BX,SCREEN_MAX_X- BARRIER_HORIZONTAL_SIZE
	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER LENGTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                        CMP                 BX,AX
	                        JAE                 GOOD_LENGTH2
	                        MOV                 LENMAX,SCREEN_MAX_X

	GOOD_LENGTH2:            
	                        MOV                 AX,Y_BARRIER2
	                        CMP                 AX,SCREEN_MAX_Y
	                        JE                  DONT_DRAW2                  	;; IF Y== LAST COLUMN OF PIXELS THEN DONT DRAW
	                        MOV                 BX,SCREEN_MAX_Y- BARRIER_VERTICAL_SIZE
	                        CMP                 BX,AX                      	;IF(BX>=AX) THEN NOTHING,,,,, ELSE -> THE BARRIER WIDTH WILL BE OUT OF THE SCREEN AND HAVE TO BE SHORTENED
	                        JAE                 GOOD_WIDTH2

	                        MOV                 WIDMAX,SCREEN_MAX_Y

	GOOD_WIDTH2:             
	                        CALL                FILLRECTANGLE

	DONT_DRAW2:              
	                        RET
CHECK_BOUNDARY_BARRIER2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECK_OVERLAPPING_BARRIER2 PROC FAR

	                               MOV                 AX,X_BARRIER2
	                               CMP                 AX,X_BARRIER1
	                               JGE                 CHECK_LESS_X1               ; if x2>= x1 then go check if x2 is less than x1+its length
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER2
	CHECK_LESS_X1:                 
	                               MOV                 AX,X_BARRIER1
	                               ADD                 AX, BARRIER_HORIZONTAL_SIZE
	                               MOV                 BX,X_BARRIER2
	                               CMP                 BX,AX
	                               JLE                 X2_OVERLAPS                               ;this means it overlaps
	                               JMP                 END_CHECK_OVERLAPPING_BARRIER2
	X2_OVERLAPS:  ;if barrier 2 overlaps with barrier 1,make barrier2 start at the end of barrier1                   
	                               MOV                 AX,X_BARRIER1
	                               ADD                 AX, BARRIER_HORIZONTAL_SIZE
	                               MOV                 X_BARRIER2,AX
	


	END_CHECK_OVERLAPPING_BARRIER2:
	                               RET
CHECK_OVERLAPPING_BARRIER2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOVING BARRIER 1,2 
MOVE_BARRIERS PROC FAR


												MOV AX,x_barrier1
												MOV PRE_POSITION_X,AX
												MOV AX,Y_barrier1
												MOV PRE_POSITION_Y,AX

												MOV AX,x_barrier2
												MOV PRE_POSITION_X2,AX
												MOV AX,Y_barrier2
												MOV PRE_POSITION_Y2,AX
											
												CHECK_BARRIER1_TOP:			;check if barrier1 reach top of page(before reaching health bar)
																	CMP Y_BARRIER1 ,24 			                            
																	JLE BARRIER_1_REACHED_TOP
																	JG BARRIERS_1_DIDNT_REACH_TOP

												BARRIER_1_REACHED_TOP: 		;If reached top of page return it to the bottom
																	 Mov Y_BARRIER1,Initial_Y_Barrier1
																	 ;Change the X-position of the Barrier
																	check_x1:
																				CMP X_BARRIER1,260;10<=x_barrier_1<= 260  
																				JGE X1_REACH_MAX 
																				JL X1_DONT_REACH_MAX                  
														
																	X1_REACH_MAX:
																				SUB X_BARRIER1,200
																				JMP CHECK_BARRIER2_TOP

																	X1_DONT_REACH_MAX:
																					ADD X_BARRIER1,50  ;;10-->60-->120.....--->260
																					JMP CHECK_BARRIER2_TOP

												BARRIERS_1_DIDNT_REACH_TOP:		;moving barriers up
																	SUB Y_Barrier1,1		;5 steps by which the barriers are moving
												
												CHECK_BARRIER2_TOP: 		;check if barrier2 reach top of page(before reaching health bar)
																	CMP Y_BARRIER2 ,24 			                            
																	JLE BARRIER_2_REACHED_TOP
																	JG BARRIERS_2_DIDNT_REACH_TOP

												BARRIER_2_REACHED_TOP: 
																	 Mov Y_BARRIER2,Initial_Y_Barrier2
																	 ;Randomize the X-position of the Barrier
																	check_x2:
																			CMP X_BARRIER2,10;10<=x_barrier_1<= 260  
																			JLE X2_REACH_MAX 
																			JG X2_DONT_REACH_MAX                  
														
																	X2_REACH_MAX:
																				ADD X_BARRIER2,200	
																				JMP X_TEMP_LABEL

																	X2_DONT_REACH_MAX:
																					SUB X_BARRIER2,50	;;260-->210-->...-->10
																					JMP X_TEMP_LABEL
																						

												BARRIERS_2_DIDNT_REACH_TOP:		;moving barriers up
																	SUB Y_Barrier2,2		;5 steps by which the barriers are moving
												
												

												X_TEMP_LABEL:		
												CALL DRAW_BARRIER1
												CALL DRAW_BARRIER2
												CALL first_player_barriers_coli
												CALL second_player_barriers_coli


							RET
												
MOVE_BARRIERS ENDP

END MAIN