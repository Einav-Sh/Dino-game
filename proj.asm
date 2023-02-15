IDEAL
MODEL small
STACK 256

DATASEG
	GAME_WIDTH DW 140h
	
	DINO_Y DW 90h
	DINO_X DW 20h
	DINO_X_SIZE DW 3h
	DINO_Y_SIZE DW 100h

	CACTUS_X DW 140h
	CACTUS_Y DW 90h
	CACTUS_X_SIZE DW 8h
	CACTUS_Y_SIZE DW 16h
	CACTUS_SPEED DW 05h
	
	BIRD_X DW 200h
	BIRD_Y DW 79h
	BIRD_X_SIZE DW 16h
	BIRD_Y_SIZE DW 6h
	
	TIME_VAR DB 0
	
	FLAG1 DW 0h
	FLAG2 DW 0h
	EXIT_FLAG DW 0h
	
	SCORE_TIME DW 0h
	SCORE1 DB 0h
	SCORE2 DB 0h
	SCORE3 DB 0h
	SCORE4 DB 0h

	DISPLAY_TEXT1 DB '0','$'
	DISPLAY_TEXT2 DB '0','$'
	DISPLAY_TEXT3 DB '0','$'
	DISPLAY_TEXT4 DB '0','$'
	DISPLAY_TEXTH1 DB '0','$'
	DISPLAY_TEXTH2 DB '0','$'
	DISPLAY_TEXTH3 DB '0','$'
	DISPLAY_TEXTH4 DB '0','$'
	GAMEOVER_TEXT DB 'GAMEOVER ):','$'
	HSCR DB 'HIGHSCORE:','$'
	
	starting_screen_text db "[ Welcome to Dino-run game! ]", 10,10, "Your goal is to move the dino (white cube), avoid the cacti and  birds to score as much as possible. If you let them touch  the dino, you'll lose the game!", 10,10, "Controls:", 10, "w,s - move the dino - up and down", 10,10, "Made by Einav Sh", 10,10,10, "- Press any key to start the game -$"
	lose_screen_text db 10, "[ You lost! ]", 10,10, "You You collided with a cactus or a bird... Oh   no... Now you'll have to do it all over again!", 10,10,10, "- Press a key to exit -$"

	HIGHSCORE DW 0h
	SCORE_PRES DW 0h
	
	;random:
	RANDOM_NUM DW ?

CODESEG

MACRO GAMEOVER_GAM 
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 01h
	int 10h
	
    mov ah, 09h
    mov dx, offset lose_screen_text
    int 21h
	
	mov ah, 00h
	int 16h
	
	cmp AL, 77h
	jne EXIT5
	call RESET_GAME
	jmp GAMEON
	
ENDM

PROC main  near

	call CLEAR_SCREEN
	TIME_CHECK:
		
		mov ah, 2ch
		int 21h
		
		cmp dl, [TIME_VAR]
		JE TIME_CHECK
		
		inc [SCORE_TIME]
		cmp [SCORE_TIME], 5h
		jne NO_SCORE
		call UPDATE_SCORE
		mov [SCORE_TIME], 00h
		
		NO_SCORE:
		call COLLISION_CHECK
		cmp [EXIT_FLAG], 00h
		jne GAMEOVER
		jmp GAMEON
		
		GAMEOVER:
			call PUT_SCORE
			call CMP_HIGHSCORE
			GAMEOVER_GAM
			
		GAMEON:
		call CACTUS_MOVE
		call BIRD_MOVE
		mov [TIME_VAR], dl
		call CLEAR_SCREEN
		call GROUND_DRAW
		call DINO_MOVE
		cmp [FLAG2], 1h
		je SCHAR
		call DINO_DRAW_STAND
		jmp EXIT3
		
		SCHAR:
		call DINO_DRAW_CROUCH
		 
		EXIT3:
		call CACTUS_DRAW
		call BIRD_DRAW
		call DRAW_SCORE
		call PRINT_HIGHSCORE
		call DRAW_HSCORE
		jmp TIME_CHECK
	EXIT5:
	RET                          
	
ENDP main 

proc starting_screen
    mov ah, 09h
    mov dx, offset starting_screen_text
    int 21h

    mov ah, 00h
    int 16h

    ret
endp

PROC GROUND_DRAW  near
	mov dl, 00h
	CHAR1_LOOP:
		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		int 10h
		mov ah, 09h
		mov al, 28h   ;char1
		mov bh, 00h
		mov bl, 0fh
		mov cx, 01h
		int 10h
		inc dl
	CHAR2_LOOP:
		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		int 10h
		mov ah, 09h
		mov al, 3ah   ;char2
		mov bh, 00h 
		mov bl, 0fh
		mov cx, 01h
		int 10h
		inc dl
		cmp dl, 28h
		jne CHAR1_LOOP
	RET
ENDP GROUND_DRAW 

PROC DINO_DRAW_STAND  near      
	mov [DINO_Y_SIZE], 16h
	mov cx, [DINO_X]
	mov dx, [DINO_Y]
	
	mov bh, 0h
	mov al, 0fh
	mov ah, 0ch

	mov cx, [DINO_X]    ;1*
	add cx, 3
	mov dx, [DINO_Y] 
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	
	mov cx, [DINO_X]    ;2*
	add cx, 3
	mov dx, [DINO_Y] 
	sub dx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h

	mov cx, [DINO_X]    ;3*
	add cx, 3
	mov dx, [DINO_Y]
	sub dx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	
	mov cx, [DINO_X]    ;4*
	add cx, 2
	mov dx, [DINO_Y]
	sub dx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	
	mov cx, [DINO_X]    ;5*
	add cx, 1
	mov dx, [DINO_Y]
	sub dx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	
	mov cx, [DINO_X]    ;6*
	mov dx, [DINO_Y]
	sub dx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	
	mov cx, [DINO_X]    ;7*
	mov dx, [DINO_Y]
	sub dx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	
	mov cx, [DINO_X]    ;8*
	mov dx, [DINO_Y]
	sub dx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	
	mov cx, [DINO_X]    ;9*
	mov dx, [DINO_Y]
	sub dx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h

	mov cx, [DINO_X]    ;10*
	mov dx, [DINO_Y]
	sub dx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h

	mov cx, [DINO_X]    ;11*
	add cx, 7
	mov dx, [DINO_Y]
	sub dx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	
	mov cx, [DINO_X]    ;12*
	add cx, 7
	mov dx, [DINO_Y]
	sub dx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	
	mov cx, [DINO_X]    ;13*
	add cx, 7
	mov dx, [DINO_Y]
	sub dx, 12
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	
	mov cx, [DINO_X]    ;14*
	add cx, 7
	mov dx, [DINO_Y]
	sub dx, 13
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	
	mov cx, [DINO_X]    ;15*
	add cx, 8
	mov dx, [DINO_Y]
	sub dx, 14
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	
	RET

ENDP DINO_DRAW_STAND 

PROC DINO_DRAW_CROUCH  near
	mov cx, [DINO_X]
	mov dx, [DINO_Y]
	
	mov bh, 0h
	mov al, 0fh
	mov ah, 0ch

	mov cx, [DINO_X]    ;1*
	add cx, 7
	mov dx, [DINO_Y] 
	int 10h
	mov cx, [DINO_X]
	add cx, 18
	int 10h

	mov cx, [DINO_X]    ;2*
	add cx, 6
	mov dx, [DINO_Y] 
	sub dx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 16
	int 10h
	mov cx, [DINO_X]
	add cx, 17
	int 10h
	
	mov cx, [DINO_X]    ;3*
	add cx, 6
	mov dx, [DINO_Y] 
	sub dx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	mov cx, [DINO_X]
	add cx, 13
	int 10h
	mov cx, [DINO_X]
	add cx, 14
	int 10h
	mov cx, [DINO_X]
	add cx, 15
	int 10h
	mov cx, [DINO_X]
	add cx, 16
	int 10h
	mov cx, [DINO_X]
	add cx, 17
	int 10h
	mov cx, [DINO_X]
	add cx, 20
	int 10h
	mov cx, [DINO_X]
	add cx, 21
	int 10h
	mov cx, [DINO_X]
	add cx, 22
	int 10h
	mov cx, [DINO_X]
	add cx, 23
	int 10h
	mov cx, [DINO_X]
	add cx, 24
	int 10h

	mov cx, [DINO_X]    ;4*
	add cx, 4
	mov dx, [DINO_Y] 
	sub dx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	mov cx, [DINO_X]
	add cx, 13
	int 10h
	mov cx, [DINO_X]
	add cx, 14
	int 10h
	mov cx, [DINO_X]
	add cx, 15
	int 10h
	mov cx, [DINO_X]
	add cx, 16
	int 10h
	mov cx, [DINO_X]
	add cx, 17
	int 10h
	mov cx, [DINO_X]
	add cx, 18
	int 10h
	mov cx, [DINO_X]
	add cx, 19
	int 10h
	mov cx, [DINO_X]
	add cx, 20
	int 10h
	mov cx, [DINO_X]
	add cx, 21
	int 10h
	mov cx, [DINO_X]
	add cx, 22
	int 10h
	mov cx, [DINO_X]
	add cx, 23
	int 10h
	mov cx, [DINO_X]
	add cx, 24
	int 10h
	mov cx, [DINO_X]
	add cx, 25
	int 10h
	
	mov cx, [DINO_X]    ;5*
	add cx, 1
	mov dx, [DINO_Y] 
	sub dx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 4
	int 10h
	mov cx, [DINO_X]
	add cx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 6
	int 10h
	mov cx, [DINO_X]
	add cx, 7
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	mov cx, [DINO_X]
	add cx, 13
	int 10h
	mov cx, [DINO_X]
	add cx, 14
	int 10h
	mov cx, [DINO_X]
	add cx, 15
	int 10h
	mov cx, [DINO_X]
	add cx, 16
	int 10h
	mov cx, [DINO_X]
	add cx, 17
	int 10h
	mov cx, [DINO_X]
	add cx, 18
	int 10h
	mov cx, [DINO_X]
	add cx, 19
	int 10h
	mov cx, [DINO_X]
	add cx, 20
	int 10h
	mov cx, [DINO_X]
	add cx, 22
	int 10h
	mov cx, [DINO_X]
	add cx, 23
	int 10h
	mov cx, [DINO_X]
	add cx, 24
	int 10h
	mov cx, [DINO_X]
	add cx, 25
	int 10h
		
	mov cx, [DINO_X]    ;6*
	mov dx, [DINO_Y] 
	sub dx, 5
	int 10h
	mov cx, [DINO_X]
	add cx, 1
	int 10h
	mov cx, [DINO_X]
	add cx, 2
	int 10h
	mov cx, [DINO_X]
	add cx, 3
	int 10h
	mov cx, [DINO_X]
	add cx, 8
	int 10h
	mov cx, [DINO_X]
	add cx, 9
	int 10h
	mov cx, [DINO_X]
	add cx, 10
	int 10h
	mov cx, [DINO_X]
	add cx, 11
	int 10h
	mov cx, [DINO_X]
	add cx, 12
	int 10h
	mov cx, [DINO_X]
	add cx, 13
	int 10h
	mov cx, [DINO_X]
	add cx, 14
	int 10h
	mov cx, [DINO_X]
	add cx, 15
	int 10h
	mov cx, [DINO_X]
	add cx, 16
	int 10h
	mov cx, [DINO_X]
	add cx, 20
	int 10h
	mov cx, [DINO_X]
	add cx, 21
	int 10h
	mov cx, [DINO_X]
	add cx, 22
	int 10h
	mov cx, [DINO_X]
	add cx, 21
	int 10h
	mov cx, [DINO_X]
	add cx, 22
	int 10h
	mov cx, [DINO_X]
	add cx, 23
	int 10h
	mov cx, [DINO_X]
	add cx, 24
	int 10h
	mov cx, [DINO_X]
	add cx, 25
	int 10h
	
	mov cx, [DINO_X]    ;7*
	mov dx, [DINO_Y] 
	sub dx, 6
	int 10h

	RET
	
ENDP DINO_DRAW_CROUCH  

PROC DINO_MOVE  near

	cmp [DINO_Y], 90h
	jne MOVE_DINO_UP
	
	mov ah, 01
	int 16h
	jz EXIT_KEY
	
	mov ah, 00h
	int 16h
	
	cmp al, 77h
	je MOVE_DINO_UP
	
	cmp al, 73h
	je MOVE_DINO_DOWN
	
	cmp al,1bh
	mov ax,4c00h
	int 21h

	
	jne EXIT_KEY
	
	MOVE_DINO_UP:
		mov ah, 01
		int 16h
		jz MOVEUP1
		
		mov ah, 00h
		int 16h
		
		cmp al, 73h
		je MOVE_DINO_DOWN
		MOVEUP1:
		mov [FLAG2], 00h
		mov ax, [FLAG1]
		cmp ax, 01h
		je MOVEDOWN
		
		MOVEUP:
			sub [DINO_Y], 05h
			mov bx, [DINO_Y]
			cmp [DINO_Y], 40h
			jnl EXIT_KEY
			inc ax
			
			mov [FLAG1], ax

		
		MOVEDOWN:
			add [DINO_Y], 05h
			cmp [DINO_Y], 90h
			jng EXIT_KEY
			mov [DINO_Y], 90h
			mov ax, [FLAG1]
			dec ax
			mov [FLAG1], ax
			jmp EXIT_KEY
			
	MOVE_DINO_DOWN: 
		mov [FLAG2], 01h
		mov [DINO_Y], 90h 
		jmp EXIT_KEY
	
	EXIT_KEY:
	RET
	
ENDP DINO_MOVE 

PROC CACTUS_DRAW  near
	mov bh, 0h
	mov al, 0ah
	mov ah, 0ch

	mov cx, [CACTUS_X]    ;1*
	add cx, 2
	mov dx, [CACTUS_Y] 
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h

	mov cx, [CACTUS_X]    ;2*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 1
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	
	mov cx, [CACTUS_X]    ;3*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h

	mov cx, [CACTUS_X]    ;4*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h

	mov cx, [CACTUS_X]    ;5*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 4
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	
	mov cx, [CACTUS_X]    ;6*
	add cx, 0
	mov dx, [CACTUS_Y] 
	sub dx, 5
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 1
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	
	mov cx, [CACTUS_X]    ;7*
	add cx, 0
	mov dx, [CACTUS_Y] 
	sub dx, 6
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 4
	int 10h
	
	mov cx, [CACTUS_X]    ;8*
	add cx, 0
	mov dx, [CACTUS_Y] 
	sub dx, 7
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 5
	int 10h
	
	mov cx, [CACTUS_X]    ;9*
	add cx, 0
	mov dx, [CACTUS_Y] 
	sub dx, 8
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 5
	int 10h
	
	mov cx, [CACTUS_X]    ;10*
	add cx, 0
	mov dx, [CACTUS_Y] 
	sub dx, 9
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 2
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 5
	int 10h
	
	mov cx, [CACTUS_X]    ;11*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 10
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 5
	int 10h

	mov cx, [CACTUS_X]    ;12*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 11
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 5
	int 10h

	mov cx, [CACTUS_X]    ;13*
	add cx, 2
	mov dx, [CACTUS_Y] 
	sub dx, 12
	int 10h
	mov cx, [CACTUS_X]    
	add cx, 3
	int 10h		
	
	RET
ENDP CACTUS_DRAW 

PROC CACTUS_MOVE  near
	
	cmp [CACTUS_X], 08h
	jng RESET
	
	mov ax, [CACTUS_SPEED]
	sub [CACTUS_X], ax
	jmp NEXT
	RESET:
	mov ax, [GAME_WIDTH]
	mov [CACTUS_X], ax
	NEXT:
	RET
ENDP CACTUS_MOVE 

PROC BIRD_DRAW  near
	
	mov bh, 0h
	mov al, 06h
	mov ah, 0ch

	mov cx, [BIRD_X]    ;1*
	add cx, 8
	mov dx, [BIRD_Y] 
	int 10h

	mov cx, [BIRD_X]    ;2*
	add cx, 8
	mov dx, [BIRD_Y] 
	sub dx, 1
	int 10h
	mov cx, [BIRD_X]
	add cx, 9
	int 10h

	mov cx, [BIRD_X]    ;3*
	add cx, 8
	mov dx, [BIRD_Y] 
	sub dx, 2
	int 10h
	mov cx, [BIRD_X]
	add cx, 9
	int 10h
	mov cx, [BIRD_X]
	add cx, 10
	int 10h
	mov cx, [BIRD_X]
	add cx, 11
	int 10h

	mov cx, [BIRD_X]    ;4*
	add cx, 8
	mov dx, [BIRD_Y] 
	sub dx, 3
	int 10h
	mov cx, [BIRD_X]
	add cx, 9
	int 10h
	mov cx, [BIRD_X]
	add cx, 10
	int 10h
	mov cx, [BIRD_X]
	add cx, 11
	int 10h
	mov cx, [BIRD_X]
	add cx, 12
	int 10h
	mov cx, [BIRD_X]
	add cx, 13
	int 10h
	mov cx, [BIRD_X]
	add cx, 14
	int 10h
	mov cx, [BIRD_X]
	add cx, 15
	int 10h
	mov cx, [BIRD_X]
	add cx, 16
	int 10h
	mov cx, [BIRD_X]
	add cx, 17
	int 10h
	
	mov cx, [BIRD_X]    ;5*
	add cx, 7
	mov dx, [BIRD_Y] 
	sub dx, 4
	int 10h
	mov cx, [BIRD_X]
	add cx, 8
	int 10h
	mov cx, [BIRD_X]
	add cx, 9
	int 10h
	mov cx, [BIRD_X]
	add cx, 10
	int 10h
	mov cx, [BIRD_X]
	add cx, 11
	int 10h
	mov cx, [BIRD_X]
	add cx, 12
	int 10h
	mov cx, [BIRD_X]
	add cx, 13
	int 10h
	mov cx, [BIRD_X]
	add cx, 14
	int 10h
	mov cx, [BIRD_X]
	add cx, 15
	int 10h
	mov cx, [BIRD_X]
	add cx, 16
	int 10h
	mov cx, [BIRD_X]
	add cx, 17
	int 10h
	mov cx, [BIRD_X]
	add cx, 18
	int 10h
	
	mov cx, [BIRD_X]    ;6*
	add cx, 5
	mov dx, [BIRD_Y] 
	sub dx, 5
	int 10h
	mov cx, [BIRD_X]
	add cx, 6
	int 10h
	mov cx, [BIRD_X]
	add cx, 7
	int 10h
	mov cx, [BIRD_X]
	add cx, 8
	int 10h
	mov cx, [BIRD_X]
	add cx, 9
	int 10h
	mov cx, [BIRD_X]
	add cx, 10
	int 10h
	mov cx, [BIRD_X]
	add cx, 11
	int 10h
	mov cx, [BIRD_X]
	add cx, 12
	int 10h
	mov cx, [BIRD_X]
	add cx, 13
	int 10h
	mov cx, [BIRD_X]
	add cx, 14
	int 10h
	
	mov cx, [BIRD_X]    ;7*
	add cx, 0
	mov dx, [BIRD_Y] 
	sub dx, 6
	int 10h
	mov cx, [BIRD_X]
	add cx, 1
	int 10h
	mov cx, [BIRD_X]
	add cx, 2
	int 10h
	mov cx, [BIRD_X]
	add cx, 3
	int 10h
	mov cx, [BIRD_X]
	add cx, 4
	int 10h
	mov cx, [BIRD_X]
	add cx, 5
	int 10h

	mov cx, [BIRD_X]    ;8*
	add cx, 2
	mov dx, [BIRD_Y] 
	sub dx, 7
	int 10h
	mov cx, [BIRD_X]
	add cx, 3
	int 10h
	mov cx, [BIRD_X]
	add cx, 4
	int 10h
	
	RET
ENDP BIRD_DRAW 

PROC BIRD_MOVE  near

	cmp [BIRD_X], 08h
	jng RESET1
	
	mov ax, [CACTUS_SPEED]
	sub [BIRD_X], ax
	jmp NEXT2
	RESET1:
	mov ax, [GAME_WIDTH]
	mov [BIRD_X], ax
	NEXT2:
	RET
ENDP BIRD_MOVE 

PROC COLLISION_CHECK  near
	
	mov ax, [CACTUS_X]
	sub ax, [CACTUS_X_SIZE]
	cmp [DINO_X], ax
	jnge BIRD_CHECK
	mov ax, [DINO_X]
	sub ax, [DINO_X_SIZE]
	cmp [CACTUS_X], ax
	jnge BIRD_CHECK
	
	mov ax, [CACTUS_Y]
	sub ax, [CACTUS_Y_SIZE]
	cmp [DINO_Y], ax
	jl BIRD_CHECK
	
	inc [EXIT_FLAG]
	jmp EXIT4
	
	BIRD_CHECK:
	
	mov ax, [BIRD_X]
	sub ax, [BIRD_X_SIZE]
	cmp [DINO_X], ax
	jnge EXIT4
	mov ax, [DINO_X]
	sub ax, [DINO_X_SIZE]
	cmp [BIRD_X], ax
	jnge EXIT4
	
	mov ax, [BIRD_Y]
	sub ax, [BIRD_Y_SIZE]
	cmp [DINO_Y], ax
	jl EXIT4
	
	mov ax, [DINO_Y]
	sub ax, [DINO_Y_SIZE]
	cmp ax, [BIRD_Y]
	jg EXIT4
	
	inc [EXIT_FLAG]
	EXIT4:
	RET
ENDP COLLISION_CHECK 

PROC DRAW_SCORE  near
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 24h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXT1]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 25h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXT2]
	int 21h	
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 26h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXT3]
	int 21h	
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 01h
	mov dl, 27h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXT4]
	int 21h	
	
	RET
ENDP DRAW_SCORE 

PROC UPDATE_SCORE  near
	
	cmp [SCORE4], 09h
	je UPDATE_DIGIT3
	inc [SCORE4]
	mov ax, 0h
	mov al, [SCORE4]
	add al, 30h
	mov [DISPLAY_TEXT4], al
	jmp EXIT6
	
	UPDATE_DIGIT3:
		mov [SCORE4], 00h
		mov ax, 0h
		add al, 30h
		mov [DISPLAY_TEXT4], al
		
		cmp [SCORE3], 09h
		je UPDATE_DIGIT2
		
		inc [SCORE3]
		mov ax, 0h
		mov al, [SCORE3]
		add al, 30h
		mov [DISPLAY_TEXT3], al
		jmp EXIT6
		
	UPDATE_DIGIT2:
		mov [SCORE3], 00h
		mov ax, 0h
		add al, 30h
		mov [DISPLAY_TEXT3], al
		
		cmp [SCORE2], 09h
		je UPDATE_DIGIT1
		
		inc [SCORE2]
		mov ax, 0h
		mov al, [SCORE2]
		add al, 30h
		mov [DISPLAY_TEXT2], al
		jmp EXIT6
		
	UPDATE_DIGIT1:
		mov [SCORE2], 00h
		mov ax, 0h
		add al, 30h
		mov [DISPLAY_TEXT2], al
		
		inc [SCORE1]
		mov ax, 0h
		mov al, [SCORE1]
		add al, 30h
		mov [DISPLAY_TEXT1], al
		jmp EXIT6
		
	EXIT6:
	RET
ENDP UPDATE_SCORE 

PROC RESET_GAME  near
	mov [DINO_Y], 90h
	mov [DINO_X], 20h
	
	mov [CACTUS_X], 140h
	mov [CACTUS_Y], 90h
	
	mov [BIRD_X], 200h
	mov [BIRD_Y], 85h
	
	mov [FLAG1], 0h
	mov [FLAG2], 0h
	mov [EXIT_FLAG], 0h
	
	mov [SCORE_TIME], 0h
	
	mov [SCORE1], 0h
	mov [SCORE2], 0h
	mov [SCORE3], 0h
	mov [SCORE4], 0h
	mov [DISPLAY_TEXT1], 30h
	mov [DISPLAY_TEXT2], 30h
	mov [DISPLAY_TEXT3], 30h
	mov [DISPLAY_TEXT4], 30h
	
	mov ax, 00h
	mov dx, 00h
	mov cx, 00h
	mov bx, 00h
	
	RET
ENDP RESET_GAME 

PROC PUT_SCORE  near
	
	mov al, [SCORE3]
	mov bl, 10h
	mul bl
	mov dl, al
	add dl, [SCORE4]
	mov al, [SCORE1]
	mov bl, 10h
	mul bl
	mov dh, al
	add dh, [SCORE2]
	mov [SCORE_PRES], dx
	RET
ENDP PUT_SCORE 

PROC CMP_HIGHSCORE  near
	mov dx, [HIGHSCORE]
	cmp dx, [SCORE_PRES]
	jg EXIT7
	
	mov dx, [SCORE_PRES]
	mov [HIGHSCORE], dx
	mov al, dh
	mov bl, 10h
	div bl
	add ah, 30h
	add al, 30h 
	mov [DISPLAY_TEXTH1], al
	mov [DISPLAY_TEXTH2], ah
	
	mov ax, 00h
	mov al, dl
	mov bl, 10h
	div bl
	add ah, 30h
	add al, 30h
	mov [DISPLAY_TEXTH3], al
	mov [DISPLAY_TEXTH4], ah
	EXIT7:
	RET
ENDP CMP_HIGHSCORE 


PROC DRAW_HSCORE  near
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 02h
	mov dl, 24h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXTH1]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 02h
	mov dl, 25h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXTH2]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 02h
	mov dl, 26h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXTH3]
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 02h
	mov dl, 27h
	int 10h
	
	mov ah, 09h
	lea dx, [DISPLAY_TEXTH4]
	int 21h
	
	RET
ENDP DRAW_HSCORE 

PROC PRINT_HIGHSCORE  near
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 02h
	mov dl, 19h
	int 10h
	
	mov ah, 09h
	lea dx, [HSCR]
	int 21h
	RET
ENDP PRINT_HIGHSCORE 

PROC CLEAR_SCREEN  near
	mov ah, 00h
	mov al, 13h
	int 10h
	
	mov ah, 0bh
	mov bh, 00h
	mov bl, 00h
	int 10h
	
	RET
ENDP CLEAR_SCREEN 
	
start:
    mov ax, @data
    mov ds, ax
	
	call starting_screen
    call main


exit:
    mov ah, 4Ch
    int 21h

END start
