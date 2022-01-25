[org 0x0100]
jmp start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    welcome_message: db 'Welcome To The Snake Game!'
    welcomeTwo:           db 'Press Any Key To Play'
    welcomeTwoLength:  dw 21
    Over: db 'Game Over!'
    OverLength: dw 10
    welcome_message_length: dw 26
    intial_snake_length: dw 5


    title:      db   'SnakeASM'   
    length:     dw   8
    scoreTitle: db   'Score = '
    scoreLength:dw   8
    score:      dw   0
    livesTitle: db   'Lives = '
    livesLength:dw   8
    lives:      dw   3
    sym:        db   '═'
    sym1:       db   '|'
    hurdle:     db   'X'
    food_location:dw 1950
    mine_location:dw 1750

    count: dw 0
    temp: dw 0

    snake: db 02,'*','*','*','*'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function Will Clear Screen
clrscr:     
    push es
    push ax
    push di

    mov  ax, 0xb800
    mov  es, ax
    mov  di, 0

    nextloc:
        mov  word [es:di], 0x0720
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di 
    pop  ax
    pop  es
    ret
;Make Snake
draw_snake:
    push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx

    mov si, [bp + 6]        ;snake
    mov cx, [bp + 8]        ;length of snake
    mov di, 1996
    mov ax, 0xb800
    mov es, ax

    mov bx, [bp + 4]
    mov ah, 0x09
    snake_next_part:
        mov al, [si]02
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2

        add di, 2
        loop snake_next_part

    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 6
; subroutine for moving snake left
move_snake_left:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    sub dx, 2
    check_left_colision:
        cmp dx, [bx]
        je no_left_movement
        add bx, 2
        loop check_left_colision
    left_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax
    left_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop left_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_left_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;SubRoutine for Up movement
move_snake_up:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    sub dx, 160
    check_up_colision:
        cmp dx, [bx]
        je no_up_movement
        add bx, 2
        loop check_up_colision
    upward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax
    up_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop up_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    no_up_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;SubRoutine for Down Movement
move_snake_down:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    add dx, 160
    check_down_colision:
        cmp dx, [bx]
        je no_down_movement
        add bx, 2
        loop check_down_colision

    downward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax
    down_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        loop down_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_down_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
move_snake_right:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    add dx, 2
    check_right_colision:
        cmp dx, [bx]
        je no_right_movement
        add bx, 2
        loop check_right_colision

    right_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax
    right_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop right_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_right_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;Moving Snake
move_snake:
    ; Get keystroke
    push ax
    push bx

    repeat:
    mov ah,0
    int 0x16
    ; AH = BIOS scan code
    cmp ah,0x48
    je up
    cmp ah,0x4B
    je left
    cmp ah,0x4D
    je right
    cmp ah,0x50
    je down
    cmp ah,1
    jne repeat      ; loop until Esc is pressed
    ;Escape check
    mov ah,0x4c
    je exit
    ;UpWard Movement
    up:
        push word [intial_snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_up
        call Is_Snake_Collide_Hurdle
        jmp snake_eat_fruit

    down:
        push word [intial_snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_down
        jmp snake_eat_fruit

    left:
        push word [intial_snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_left
        jmp snake_eat_fruit

    right:
        push word [intial_snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_right
        jmp snake_eat_fruit
    snake_eat_fruit:
        call OutCheck
        call Is_Snake_Collide_Hurdle
        push word [food_location]
        push word [intial_snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call on_eat_food_inc_size
        jmp repeat
    exit:
        pop bx
        pop ax
        ret
; Snake Colision Detection
Is_Snake_Collide_Hurdle:
        push ax
        push es
        push di
        push bx

        mov ax, [mine_location]
        mov bx, snake_locations
        cmp [bx], ax

        jne noSubLive
            sub word [lives], 1
            mov ax, 0xb800
            mov es, ax
            mov di, [mine_location]
            mov ax, 0x0902
            mov [es:di], ax
            call RandMineGen
            push word [mine_location]
            call display_mine

        noSubLive:
        cmp word [lives], 0
        jne noSubLive2
            call GameOver
        noSubLive2:
        push 3996
        push word [lives]
        call printNum

        pop bx
        pop di
        pop es
        pop ax
        ret
;Border
border:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 2              


    mov si, [bp + 6]
    mov cx, 70
    mov ah, 0x04 ; only need to do this once 


    print: 
        cmp di, 72
        jne skip

            mov dx, title 
            push dx 
            push word [length]
            call printTName

        skip:
        mov al, [si]
        mov [es:di], ax 
        add di, 2

        loop print 

    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2

BottomBorder:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 3682              


    mov si, [bp + 6]
    mov cx, 78
    mov ah, 0x04 ; only need to do this once 


    print3: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2

        loop print3
;   // Displaying Score
    mov dx, 3842
    push dx
    mov dx, scoreTitle 
    push dx 
    push word [scoreLength]
    call printName

    mov dx, 3858
    push dx
    mov dx, [score]
    push dx 
    call printNum

;   // Displaying Lives
    mov dx, 3980
    push dx
    mov dx, livesTitle 
    push dx 
    push word [livesLength]
    call printName

    mov dx, 3996
    push dx
    mov dx, [lives]
    push dx 
    call printNum



    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2


Hborder:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 160              


    mov si, [bp + 4]
    mov cx, 22
    mov ah, 0x04 ; only need to do this once 


    print2: 
        mov al, [si]
        mov [es:di], ax 
        add di, 158
        mov [es:di], ax 
        add di, 2

        loop print2 


    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 2

printTName:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    ; push di 

    mov ax, 0xb800 
    mov es, ax 
    mov di, 72               


    mov si, [bp + 6]
    mov cx, [bp + 4]
    mov ah, 0x02 ; only need to do this once 

    nextchar: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2 
        add si, 1 
        
        loop nextchar 


    ; pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 4 

printName:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 
    mov es, ax 
    ;// Displaying Score
    ; mov di, 3842             

    mov di, [bp + 8]
    mov si, [bp + 6]
    mov cx, [bp + 4]
    mov ah, 0x02 ; only need to do this once 

    nextchar1: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2 
        add si, 1 
        

        loop nextchar1


    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 6 

printNum: 
    push bp 
    mov  bp, sp
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 

   

    mov ax, [bp+4]   
    mov bx, 10       
    mov cx, 0        

    nextdigit: 
        mov dx, 0    
        div bx       
        add dl, 0x30 
        push dx      
        inc cx       
        cmp ax, 0    
        jnz nextdigit 

    

    mov ax, 0xb800 
    mov es, ax 

    mov di, [bp + 6]
    nextpos: 
        pop dx          
        mov dh, 0x03    
        mov [es:di], dx 
        add di, 2 
        loop nextpos    

    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
    pop es
    pop bp 
    ret 4 

;display food
display_food:
    push bp
    mov bp, sp
    push ax
    push di
    push es

    mov ax, 0xb800
    mov es, ax
    mov di, [bp + 4]        ;food location
    mov ax, 0x0309 ;9, 3
    mov [es:di], ax

    pop es
    pop di
    pop ax
    pop bp
    ret 2

;display food
display_mine:
    push bp
    mov bp, sp
    push ax
    push di
    push es

    mov bh, 0x04
    mov bl, [hurdle]

    mov ax, 0xb800
    mov es, ax
    mov di, [bp + 4]        ;Mine location
    mov ax, bx ;9, 3
    mov [es:di], ax

    pop es
    pop di
    pop ax
    pop bp
    ret 2
;Increase Snake Size
on_eat_food_inc_size:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

    mov bx, [bp + 4]
    mov dx, [bp + 10]

    cmp [bx], dx
    jne not_increase_size
    ;else
    mov cx, [bp + 8]        ;snake length
    shl cx, 1
    sub cx, 2
    add bx, cx      
    mov dx, [bx]
    sub dx, [bx - 2]        ;last - second last

    mov ax, [bx]
    add ax, dx          
    mov dx, ax
   
    add cx, 2
    shr cx,1
    inc cx
    mov [intial_snake_length], cx

    add bx, 2
    mov [bx], dx
    mov si, [bp + 6]
    inc si

    mov ax, 0xb800
    mov es, ax
    mov di, dx
    mov ah, 0x07
    mov al, [si]

    mov [es:di], ax
    ;;;;;
    ;call Increase_score
    add word [score], 5

    mov ax, 0xb800 
    mov es, ax 
    mov di, [mine_location]             
    mov ax, 0x0720 
    mov [es:di], ax

    push 3858
    push word [score]
    call printNum

    push 3996
    push word [lives]
    call printNum
    
    call RandGen
    call RandMineGen 
    push word [food_location]
    call display_food
    push word [mine_location]
    call display_mine

    not_increase_size:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8
;Random Numebr
RandGen:        
push cx
push dx
push ax
push bx
push si
push di

mov word [temp], 0
RandStart:
   push cx
   mov ah, 00h  ; interrupts to get system time        
   int 1ah      ; cx:dx now hold number of clock ticks since midnight      
                
   pop cx
   mov [temp], dh
   xor dh, dh
   push dx
   xor dx, dx
   mov dl, [temp]
   pop si 
   add dx, si
   mov bx, 999   ; set limit to 999
   mov ax, dx
   cmp ax, bx       
   ja RandStart 

   mov bx, 0   ; set limit to 0
   mov ax, dx   
   cmp ax, bx
   jb RandStart 


   mov cx, [count]
   add dx, cx
   add cx, 1000
   add word [count], 1000
   cmp word [count], 4000
   jne skip1
        mov word [count], 0
        xor cx,cx

   skip1:
   cmp dx, 162
   jb RandStart

   cmp dx, 3680
   ja RandStart

   mov [temp], cx
   mov cx, dx
   shr cx, 1
   jnc move

        add dx, 1

    move:
    mov di, 160              
    mov cx, 23

    check: 
        cmp di, dx
        je RandStart

        add di, 158
        cmp di, dx
        je RandStart

        add di, 2
        cmp di, dx
        je RandStart
        loop check 


   mov cx, [temp]
;    mov word [food_location], 0
   mov word [food_location ], dx
;    add bp, 2
;    dec di
;    cmp di, 0
;    jne RandGen
    pop di
    pop si
    pop bx
    pop ax
    pop dx
    pop cx
    ret 

RandMineGen:        ; generate a rand no using the system time
push cx
push dx
push ax
push bx
push si
push di

mov word [temp], 0
RandMineStart:
   push cx
   mov ah, 00h  ; interrupts to get system time        
   int 1ah      ; cx:dx now hold number of clock ticks since midnight      
                ; lets just take the lower bits of dl for a start..
   pop cx
   mov [temp], dh
   xor dh, dh
   push dx
   xor dx, dx
   mov dl, [temp]
   pop si 
   add dx, si
   mov bx, 999   ; set limit to 999  
   mov ax, dx
   cmp ax, bx      
   ja RandMineStart 

   mov bx, 0   ; set limit to 0
   mov ax, dx   
   cmp ax, bx   
   jb RandMineStart 


   mov cx, [count]
   add dx, cx
   add cx, 1000
   add word [count], 1000
   cmp word [count], 4000
   jne skipMine
        mov word [count], 0
        xor cx,cx

   skipMine:
   cmp dx, 162
   jb RandMineStart

   cmp dx, 3680
   ja RandMineStart

   mov [temp], cx
   mov cx, dx
   shr cx, 1
   jnc moveMine

        add dx, 1

    moveMine:
    mov di, 160              
    mov cx, 23

    checkMine: 
        cmp di, dx
        je RandMineStart

        add di, 158
        cmp di, dx
        je RandMineStart

        add di, 2
        cmp di, dx
        je RandMineStart
        loop checkMine 

    cmp dx, [food_location]
    je RandMineStart
   
   mov cx, [temp]
;    mov word [food_location], 0
   mov word [mine_location], dx
;    add bp, 2
;    dec di
;    cmp di, 0
;    jne RandGen
    pop di
    pop si
    pop bx
    pop ax
    pop dx
    pop cx
    ret
GameOver:
push cx
push dx
push ax
push bx
push si
push di

    call clrscr
    mov dx, 1994
    push dx
    mov dx, Over 
    push dx 
    push word [OverLength]
    call printName


pop di
pop si
pop bx
pop ax
pop dx
pop cx
mov ax, 0x4c00
int 0x21
ret 

OutCheck:
push ax
push di
push cx


    mov ax, [snake_locations]
    cmp ax, 160
    jb END
    mov di, 160              
    mov cx, 22


    check1: 
        cmp ax, di
        je END
        add di, 158
        cmp ax, di
        je END
        add di, 2

        loop check1 
    
    mov di, 3680
    cmp ax, di
    ja END
    jmp else

    END:
    call GameOver
else:
pop cx
pop di
pop ax
ret

WelcomeBorder:
    mov ax, 0xb800 
    mov es, ax 
    mov di, 2126              

    mov ah, 0x04 ; only need to do this once 
    print0: 
        mov al, '-'
        mov [es:di], ax 
        add di, 2
        cmp di, 2190
        jne print0

    mov ah, 0x09
    mov al, 'P'
    mov word [es:2312], ax
    mov al, 'L'
    mov word [es:2314], ax
    mov al, 'A'
    mov word [es:2316], ax
    mov al, 'Y'
    mov word [es:2318], ax
    mov al, '!'
    mov word [es:2320], ax



    mov ah, 0x09
    mov al, '*'

    mov word [es:2], ax
    mov word [es:162], ax
    mov word [es:322], ax
    mov word [es:482], ax
    mov word [es:642], ax
    mov word [es:3996], ax
    mov word [es:3836], ax
    mov word [es:3676], ax
    mov word [es:3516], ax

    mov word [es:642], 0x0902
    mov word [es:3356], 0x0902

ret

start:
    call clrscr

    mov dx, 1972
    push dx
    mov dx, welcome_message 
    push dx 
    push word [welcome_message_length]
    call printName
    call WelcomeBorder


    mov ah, 01
    int 0x21


    call clrscr

    mov ax, sym
    push ax
    call border

    mov ax, sym1
    push ax
    call Hborder

    mov ax, sym
    push ax
    call BottomBorder

    push word [intial_snake_length]
    mov bx, snake
    push bx
    mov bx, snake_locations
    push bx
    call draw_snake

    call RandGen
    call RandMineGen
    push word [food_location]
    call display_food
    push word [mine_location]
    call display_mine

    call move_snake

    mov ax, 0x4c00
    int 0x21

snake_locations: dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
