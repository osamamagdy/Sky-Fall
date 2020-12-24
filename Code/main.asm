;include mymacros.inc
.model small
.stack 64
.data

    background_color EQU 53 ;pixel color id
    graphics_mode EQU 13h  ;320*200 pixels , 256colors

    game_width EQU 320
    game_height EQU 160

    player_width EQU 20
    player_height EQU 25
    player_size EQU 500

    p1_x DW 50
    p1_y DW 60
    p2_x DW 250
    p2_y DW 60
    

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
main proc far             
    mov ax,@data
    mov ds,ax               
    ;change the vedio mode
    call vedio_mode
    ;fill the whole screen with the background color
    call draw_background
    call draw_p1
    call draw_p2
main endp 
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;change the vedio mode to graphics mode
vedio_mode proc
    ;;;;;;;;;;;
    mov ah,0
    mov al,graphics_mode
    int 10h ;call the interrupt
    ;;;;;;;;;;;;
ret
vedio_mode endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        cmp cx,game_width
        jnz fillblue ;if not zero so we continue to the same row 
        inc dx
        mov cx,0 
        cmp dx,game_height ;if not zero so we continue to draw the background
        jnz fillblue
    ;;;;;;;;;;;;;;
ret
draw_background endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_p1 proc
;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov di,0
    mov al,p1[DI] ;the pixel color
    mov bh,0  ;the page number
    mov cx,p1_x  ;the starting x-position (column)
    add cx,player_width ;as we draw in the reversed order
    mov dx,p1_y ;the starting y-position (row)
    add dx,player_height  ;as we draw in the reversed order
    ;here we loop for the image size (player_size)
    fill_p1:
        cmp al,0
        jz pass_the_pixel
        int 10h
        pass_the_pixel:
        inc di
        mov al,p1[DI]
        dec cx
        cmp cx,p1_x
        jnz fill_p1 ;if not zero so we continue to the same row 
        mov cx,p1_x  ;the starting x-position (column)
        add cx,player_width ;as we draw in the reversed order
        dec dx ;if not zero so we continue to draw the background
        cmp dx,p1_y
        jnz fill_p1
    ;;;;;;;;;;;;;;
ret
draw_p1 endp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_p2 proc
;;;;;;;;;;;;;;
    mov ah,0ch ;this means with int 10h ---> you're drawing a pixel
    mov di,0
    mov al,p2[DI] ;the pixel color
    mov bh,0  ;the page number
    mov cx,p2_x  ;the starting x-position (column)
    add cx,player_width ;as we draw in the reversed order
    mov dx,p2_y ;the starting y-position (row)
    add dx,player_height  ;as we draw in the reversed order
    ;here we loop for the image size (player_size)
    fill_p2:
        cmp al,0
        jz pass_the_pixel_2
        int 10h
        pass_the_pixel_2:
        inc di
        mov al,p2[DI]
        dec cx
        cmp cx,p2_x
        jnz fill_p2 ;if not zero so we continue to the same row 
        mov cx,p2_x  ;the starting x-position (column)
        add cx,player_width ;as we draw in the reversed order
        dec dx ;if not zero so we continue to draw the background
        cmp dx,p1_y
        jnz fill_p2
    ;;;;;;;;;;;;;;
ret
draw_p2 endp



end main 

