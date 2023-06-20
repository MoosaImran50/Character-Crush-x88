[org 0x0100]
jmp start

pn: db ' Player Name:                ' ; string to be printed
lpn: dw 29 ; length of the string

ps: db ' Score: 0                    ' ; string to be printed
lps: dw 29 ; length of the string

tt: db ' Total moves: 15             ' ; string to be printed
ltt: dw 29 ; length of the string

pt: db ' Remaining moves: 15         ' ; string to be printed
lpt: dw 29 ; length of the string

m1: db '-'

m2: db '|'

m3: db ' '

; initialising grid with 144 zeroes indicating each index as empty
grid: dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

temp1: dw 0 ; box 1 selected

temp2: dw 0 ; box 2 selected

t1: dw 0

t2: dw 0

t3: dw 0

x1: dw 0

x2: dw 0

y1: dw 0

y2: dw 0

selected: dw 0 ; checks if the box is delected or not

flagax: dw 0 ; flag to check that is thee need for space to be stored in ax register or the current index

moves: dw 15

score: dw 0

usernamemsg: db 'Please enter your name: '
lu: dw 24

inputbs: db 'Please enter board size: '
lbs: dw 25

var1: times 100 db '$';
length: dw 0

rx: dw 0
ry: dw 0

redflag: dw 0

boardsize: dw 6

xlimit1: dw 0 ;; 49 cells or 98 bytes for 12x12

jumpnextlinei: dw 0 ; add 62 for 12x12 initialize board function

jumpnextline1: dw 0 ;; add 222 for filling spaces (12x12)

jumpnextline2: dw 0 ;;  add 224 for printboard function (12x12)

ylimit1: dw 0 ;;//

printlimit1: dw 0 ;; cmp 3860

totalcharacters: dw 0 ;; in bytes (for 12x12 characters it will be 144x2 = 288)

boardsizeword: dw 0

arraylength: dw 0 ; (0 to 143 for 12x12)

avoidlastline: dw 0

avoid2ndlastline: dw 0

downcharactercheck: dw 0

intro: db 'CHARACTER MATCH GAME' ; string to be printed

lintro: dw 20 ; length of the string

xintro: dw 30

yintro: dw 12

bombflag: dw 0

bombblast: dw 0

blastcharacter: dw 0

longspace: db '                              ' ; long space

longspacelength: dw 30

gameovermsg: db 'GAME OVER' ; messege for game end screen

lgo: dw 9 ; length of game over messege 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


boardvaluesloader:
push dx
push bx
push ax

mov dx, [boardsize]
shl dx, 2
add dx, 1
mov word[xlimit1], dx

shl dx, 1
mov bx ,160
sub bx, dx
mov word[jumpnextlinei], bx
add bx, 160
mov word[jumpnextline1], bx
add bx, 2
mov word[jumpnextline2], bx

mov bx, [boardsize]
shl bx, 1
mov word[downcharactercheck], bx

mov ax, [totalcharacters]
sub ax, bx
mov word[avoidlastline], ax
sub ax, bx
mov word[avoid2ndlastline], ax

mov ax, 0
mov al, 160
mul bx
add ax, 20
mov word[printlimit1], ax

mov bx, [boardsize];
mov ax, 0
mov al, bl
mul bx
sub ax, 1
mov word[arraylength], ax
add ax, 1
shl ax, 1
mov word[totalcharacters], ax ; total characters in bytes (characters x 2)

pop ax
pop bx
pop dx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hurdlescheck:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

mov si, 0 ; iterator
mov dx, 0 ; count of total checks
mov bx, 0 
mov cx, 0 ; horizontal index

checker:
mov bx, grid
add bx, si
add cx, 1

cmp word[bx], 0xB058
jnz nochecker

rightt:
cmp cx, [boardsize]
jae norightt
cmp word[bx+2], 0x1120
jnz leftt
mov word[bx], 0x1120
jmp nochecker

norightt:
mov cx, 0

leftt:
cmp cx, 1
jz upp
cmp word[bx-2], 0x1120
jnz upp
mov word[bx], 0x1120
jmp nochecker

upp:
mov ax, [boardsize]
shl ax, 1
mov bp, ax
cmp si, ax
jb downn
cmp word[grid+si-24], 0x1120
jnz downn
mov word[bx], 0x1120
jmp nochecker

downn:
cmp si, [avoidlastline]
jae nochecker
cmp word[grid+si+bp], 0x1120
jnz nochecker
mov word[bx], 0x1120

nochecker:
cmp cx, [boardsize]
jb yesright
mov cx, 0

yesright:
add si, 2
inc dx
cmp dx, [arraylength] ; checking if amount of checks required have been completed
jb checker ; if all checks are not done than repeat

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

removeredhighlight: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 160 ; starting index for screen printing
mov cx, 0 ; initiallizing counter for 49 characters

nextcharr:
add di, 2 ; move to next screen location
inc cx
cmp cx, [xlimit1];;
je nextliner

;3 blank spaces
mov ah, 0x11
mov al, 0x7C ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
mov al, 0x7C ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
mov al, 0x7C ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
jmp nextcharr

nextliner: ; jumping to next line after leaving black the right side
mov cx, 0
add di, [jumpnextline1];;
cmp di, [printlimit1]; end it at 24 line
jl nextcharr

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

username: ; input username
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 980 ; starting index for screen printing
mov cx, 0 ; counter
mov si, usernamemsg

mov ah, 0x03
nextcharu: ; printing
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc si
inc cx
cmp cx, [lu]
jne nextcharu

mov dh, 6
mov dl, 34
mov bh, 0
mov ah, 2
int 10h

mov di, 0 ; length
mov si, var1; ; si points towrad the address of variable 1

program:
mov ah,1
int 21h
cmp al,13 ; ascii value for enter key
je s1
mov[si],al
inc si
inc di
mov word[length], di
jmp program

s1:

; input board size
;;;;;;;;;;;;;;;;;;;;;;;;;;

call clrscr

mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 980 ; starting index for screen printing
mov cx, 0 ; counter
mov si, inputbs ; input board size

mov ah, 0x03
nextcharbs: ; printing
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc si
inc cx
cmp cx, [lbs]
jne nextcharbs

;;;;;;;;;;;;;;;;;                   

mov ah, 0x10 ; service 10 – vga attributes 
mov al, 03 ; subservice 3 – toggle blinking 
mov bl, 01 ; enable blinking bit 
int 0x10 ; call BIOS video service 

mov dx, 0
mov bl, 10

mov ah, 0 ; service 0 – get keystroke 
int 0x16 ; call BIOS keyboard service 
cmp al, 0x13
je exitBoardSize
sub al, 0x30 ; convert ascii
mov ah, 0
add dx, ax

mov ah, 0 ; service 0 – get keystroke 
int 0x16 ; call BIOS keyboard service 
cmp al, 0x13
je exitBoardSize

push ax ; saving second keystroke
mov ax, dx
mul bl
mov dx, ax
pop ax  ; returning second keystroke

sub al, 0x30 ; convert ascii
mov ah, 0
add dx, ax

exitBoardSize:
cmp dx, 1
jbe defaultSize

cmp dx, 12
ja defaultSize

jmp setSize
 
defaultSize:
mov dx, 12

setSize:
mov word [boardsize], dx

;;;;;;;;;;;

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

blastremoval: ; removes all occurences of character that was swapped with bomb
push cx
push dx
push ax
push bx

mov bx, 0
mov dx, [blastcharacter]

n1:
cmp [grid + bx], dx
jnz noremove

mov word[grid + bx], 0x1120 ; moving the space in variable
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax

noremove:
add bx, 2
cmp bx, [totalcharacters] ; 144 alphabets
jne n1

pop bx
pop ax
pop dx
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

randomNumber: ; generate a random number using the system time initialising
push cx
push dx
push ax
push bx
push di

mov bx, 0
mov di, [boardsizeword]

fill1:
rdtsc ;getting a random number in ax dx
xor dx, dx ;making dx 0
xor dx, dx ;making dx 0
mov dx, 0
mov dx, 0
mov cx, 8
div cx ;dividing by 8 to get numbers from 0-8
add dl, 1
jmp convert1

converted1:
cmp [grid + bx - 24], dx
jz fill1
cmp [grid + bx - 2], dx
jz fill1
cmp [grid + bx + 24], dx
jz fill1
cmp [grid + bx + 2], dx
jz fill1

mov [grid + bx], dx ;moving the random number in variable
add bx, 2
cmp bx, [totalcharacters] ; 288 alphabets with colours
jne fill1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov bx, 0

obstacleloop:
rdtsc ;getting a random number in ax dx
xor dx, dx ;making dx 0
xor dx, dx ;making dx 0
mov dx, 0
mov dx, 0
mov cx, [arraylength]
div cx ;
add dl, 1
mov si, dx
shl si, 1

cmp word[grid + si - 24], 0xB058
jz obstacleloop
cmp word[grid + si - 2], 0xB058
jz obstacleloop
cmp word[grid + si + 24], 0xB058
jz obstacleloop
cmp word[grid + si + 2], 0xB058
jz obstacleloop
cmp word[grid + si], 0xB058
jz obstacleloop

mov word[grid+si], 0xB058

add bx, 1
cmp bx, [boardsize]
jb obstacleloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pop di
pop bx
pop ax
pop dx
pop cx
ret

convert1:
lA1:
cmp dl, 1
jne lB1
mov dx, 0x1241
jmp converted1

lB1:
cmp dl, 2
jne lC1
mov dx, 0x1342
jmp converted1

lC1:
cmp dl, 3
jne lD1
mov dx, 0x1443
jmp converted1

lD1:
cmp dl, 4
jne lE1
mov dx, 0x1544
jmp converted1

lE1:
cmp dl, 5
jne lF1
mov dx, 0x1645
jmp converted1

lF1:
cmp dl, 6
jne lG1
mov dx, 0x1746
jmp converted1

lG1:
cmp dl, 7
jne lH1
mov dx, 0x1847
jmp converted1

lH1:
cmp dl, 8
mov dx, 0x1948
jmp converted1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

delay:
push cx
mov cx, 10 ; change the values  to increase delay time
delay_loop1:
push cx
mov cx, 0xFFFF
delay_loop2:
loop delay_loop2
pop cx
loop delay_loop1
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

longdelay:
push cx
mov cx, 500 ; change the values  to increase delay time
longdelay_loop1:
push cx
mov cx, 0xFFFF
longdelay_loop2:
loop longdelay_loop2
pop cx
loop longdelay_loop1
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; takes x position, y position, string attribute, address of string
; and its length as parameters

; subroutine to clear the screen
clrscr: 
push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov ax, 0x0720 ; space char in normal attribute
mov cx, 2000 ; number of screen locations
cld ; auto increment mode
rep stosw ; clear the whole screen
pop di
pop cx
pop ax
pop es
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fillspaces:
push cx
push dx
push ax
push bx
mov bx, 0

jmp fillstart

fill:

add bx, 2
cmp bx, [totalcharacters]
je back

fillstart:

rdtsc ;getting a random number in ax dx
xor dx, dx ;making dx 0
xor dx, dx ;making dx 0
mov dx, 0
mov dx, 0
mov cx, 8
div cx ;dividing by 8 to get numbers from 0-8
add dl, 1

cmp word[grid + bx], 0x1120
jnz fill

jmp convert

converted:
cmp [grid + bx - 24], dx
jz fillstart
cmp [grid + bx - 2], dx
jz fillstart
cmp [grid + bx + 24], dx
jz fillstart
cmp [grid + bx + 2], dx
jz fillstart

mov [grid + bx], dx ;moving the random number in variable
jmp fill

back:

pop bx
pop ax
pop dx
pop cx
ret

convert:
lA:
cmp dl, 1
jne lB
mov dx, 0x1241
jmp converted

lB:
cmp dl, 2
jne lC
mov dx, 0x1342
jmp converted

lC:
cmp dl, 3
jne lD
mov dx, 0x1443
jmp converted

lD:
cmp dl, 4
jne lE
mov dx, 0x1544
jmp converted

lE:
cmp dl, 5
jne lF
mov dx, 0x1645
jmp converted

lF:
cmp dl, 6
jne lG
mov dx, 0x1746
jmp converted

lG:
cmp dl, 7
jne lH
mov dx, 0x1847
jmp converted

lH:
cmp dl, 8
mov dx, 0x1948
jmp converted


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printboard:

mov di, 164
mov bx, 0
mov cx, 0
nextchar5:
mov ax, [grid + bx]
mov [es:di], ax ; show this char on screen
add bx, 2
add di, 8 ; move to next screen location
inc cx
cmp cx, [boardsize]
je nextline3
jmp nextchar5

nextline3: ; skipping 1 line leaving black the right side
mov cx, 0
add di, [jumpnextline2]
cmp di, [printlimit1] ; end it at 24 line
jl nextchar5

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initialize: ; initialising game board
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; starting index for screen printing
mov cx, 0 ; initiallizing counter for 49 characters

nextchar1: ; printing '|   |' pattern for whole line
mov ah, [bp+10] ; load attribute in ah
mov al, [bp+6] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
cmp cx, [xlimit1]
je nextline1

;3 blank spaces
mov ah, 0x11
mov al, [bp+6] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
mov al, [bp+6] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
mov al, [bp+6] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
jmp nextchar1

nextline1: ; jumping to next line after leaving black the right side
mov cx, 0
add di, [jumpnextlinei]
cmp di, [printlimit1]; end it at 24 line
jl nextchar1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov di, 0
nextchar2: ; printing '----' pattern for whole line
mov ah, [bp+10] ; load attribute in ah
mov al, [bp+8] ; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc cx
cmp cx, [xlimit1]
je nextline2
jmp nextchar2

nextline2: ; skipping 1 line leaving black the right side
mov cx, 0
add di, [jumpnextline1]
cmp di, [printlimit1] ; end it at 24 line
jl nextchar2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location to print player name string
mov si, [bp+22] ; ; load adress for starting index of player name string
mov cx, [bp+20] ; initiallizing counter for player name string of length 13

nextchar3: ; printing 'player name string' on right side
mov ah, [bp+24] ; load attribute in ah red bg and black fg
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextchar3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location
add di, 160 ; pointing to next line below player name where we will print player score
mov si, [bp+18] ; load adress for starting index of player score string
mov cx, [bp+16] ; initiallizing counter for player score string of length 7

nextchar4: ; printing 'player score string' on right side
mov ah, [bp+24] ; load attribute in ah red bg and black fg
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextchar4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location
add di, 320 ; pointing to next line below player name where we will print player turns
mov si, tt ; load adress for starting index of player turns string
mov cx, [ltt] ; initiallizing counter for player turns

nextchartt: ; printing 'Turns string' on right side
mov ah, [bp+24] ; load attribute in ah red bg and black fg
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextchartt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location
add di, 480 ; pointing to next line below player name where we will print player turns
mov si, [bp+32] ; load adress for starting index of player turns string
mov cx, [bp+30] ; initiallizing counter for player turns

nextchar6: ; printing 'Turns string' on right side
mov ah, [bp+24] ; load attribute in ah red bg and black fg
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextchar6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;printing input user name
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 288 ; starting index for screen printing
mov cx, 0

mov si, var1
mov ah, 0x40 ; load attribute in ah
nextcharun: ; printing
mov al, [si]; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc si
inc cx
cmp cx, [length]
jne nextcharun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call randomNumber ; fill whole grid with random alphabets from A to H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call printboard


pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret 22

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

removal:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

mov cx, 0
mov ax, 0
mov si, 0
mov bx, 0
mov di, 2                               ;;;  A A
mov dx, 0                               ;;;  A

push bp;;;;
mov bp, [downcharactercheck];;;; index of last line to check if avoiding of last line is needed
a: ; start of check

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push ax
mov ax, [score]
mov word[bombflag], ax
pop ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov word[flagax], 0 ; if flag becomes 1 then space will be moved into ax
mov ax, [grid+si] ; 1st index
mov bx, [grid+di] ; 2nd index after 1st index
inc cx

cmp ax, 0x1120 ; checking if there is space in ax and ignoring all the checks
je nospace

cmp cx, [boardsize] ; checking if ax is greater than on n-1 index than no check for adjacent right position
jae nlr ; jumping to no left right label if
cmp ax, bx ; comparing first index ax with second index bx
je lr ; check left and right adjacent conditions if both adjacent elements are same
jmp blr ; jump to back from left right

nlr: ; no left right shift because index is n-1
mov cx, 0 ; reseting the value of n to 0

blr: ; back from left right label
cmp si, [avoidlastline] ; avoiding downward check if our index is pointing to last line because no lower line exists
jae noud
cmp ax, [grid+si+bp] ; checking adjacent down index if same or not
je udf ; check up and down adjacent conditions if both adjacent elements are same

noud: ; skipping down check condition if we are in last line because there is no lower line

bud: ; back from up down label
mov bx, [flagax]
cmp bx, 1 ; checking if any adjacent index was cleared and space was stored in it 
je spaceax ; jumping to label that will clear out index that we are pointing to and storing space in it

jmp nospace ; if no adjacent index was cleared then ax will not be cleared and space will not be stored in our main index of interest

spaceax:
mov word[grid+si], 0x1120 ; clearin space and storing space in ax

push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax

nospace: ; will move to this label if no element was cleared and no spaces were stored in them
;;;;;;;;;;;;;;;;;;;;;;
push ax
push bx
mov ax, [bombflag]
mov bx, [score]
sub bx, ax
cmp bx, 3
jae createbomb
jmp nobomb

createbomb:
mov word[grid+si], 0x102A ; clearin space and storing space in ax
;;;;;;;;;;;;;;;;;;;;;;
nobomb:
pop bx
pop ax

add si, 2 ; pointing ax to next index
add di, 2 ; pointing bx to next index
inc dx ; incrementing total checks made
cmp dx, [arraylength] ; checking if amount of checks required have been completed
jb a ; if all checks are not done than repeat
jmp exit ; exit if all checks are performed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
udf:
jmp ud
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lr: ; checking left right conditions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push dx
mov dx, [boardsize]
sub dx, 1
cmp cx, dx
jae avoid3consecutive1
cmp bx, [grid+di+2]
jne avoid3consecutive1
mov word[grid+di+2], 0x1120 ; storing space in adjacent 2 right index to ax
mov word[flagax], 1 ; storing 1 in flag so ax can be filled with space later
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avoid3consecutive1:
pop dx
mov word[grid+di], 0x1120 ; storing space in adjacent right index to ax
mov word[flagax], 1 ; storing 1 in flag so ax can be filled with space later
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
jmp blr ; jumping to back from left right label

ud: ; checking up down conditions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push dx
push bx
push bp
;cmp si, [avoid2ndlastline] ; avoiding downward check if our index is pointing to 2nd last line because no lower line exists
;jae avoid3consecutive2
mov dx, [grid+si+bp]
mov bx, bp
shl bx, 1
mov bp, bx
cmp dx, [grid+si+bp]
jne avoid3consecutive2
mov word[grid+si+bp], 0x1120 ; storing space in adjacent 2 down index to ax
mov word[flagax], 1 ; storing 1 in flag so ax can be filled with space later
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avoid3consecutive2:
pop bp
pop bx
pop dx
mov word[grid+si+bp], 0x1120 ; storing space in downward index to ax
mov word[flagax], 1 ; storing 1 in flag so ax can be filled with space later
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
jmp bud ; jumping to back from up down label

exit:
pop bp;;;;

pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

swapping:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

leftright:
mov cx, [y1]
mov dx, [y2]
;imediate left and imediate right
cmp cx, dx ; checking if same rows
jnz updown
mov cx, [x1]
mov dx, [x2]
sub cx, dx
cmp cx, 1
jz replace
cmp cx, -1
jz replace

updown:
mov cx, [x1]
mov dx, [x2]
;imediate up and imediate down
cmp cx, dx ; checking if same columns
jnz skip1
mov cx, [y1]
mov dx, [y2]
sub cx, dx
cmp cx, 1
jz replace
cmp cx, -1
jz replace
jmp skip1

replace:
mov si, [temp1]
shl si, 1
mov di, [temp2]
shl di, 1
mov ax, [grid + si]
mov bx, [grid + di]
mov cx, 0 ; temp variable for swapping

mov cx, ax ; storing temp1 in temporary variable
mov ax, bx
mov bx, cx

mov word[grid + si], ax
mov word[grid + di], bx

jmp ignoreskip
;;;;;;;;;;;;;;;;;;;;;;;;;;
skip1:
jmp skip
;;;;;;;;;;;;;;;;;;;;;;;;;;
ignoreskip:

cmp ax, 0x102A
je bc1

cmp bx, 0x102A
je bc2
jmp skip

bc1:
mov word[bombblast], 1 ; now condition of bomb blast will execute after this function
mov word[blastcharacter], bx ; if ax is bomb then other character will be swapped
mov word[grid + si], 0x1120
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
jmp skip

bc2:
mov word[bombblast], 1 ; now condition of bomb blast will execute after this function
mov word[blastcharacter], ax ; if bx is bomb then other character will be swapped
mov word[grid + di], 0x1120
push ax
mov ax, [score]
add ax, 1
mov word[score], ax ; updating score
pop ax
;;;;;;;;;;;;;;;;;;;;;;;;;

skip:

pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

click: ; input mouse click
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

jmp waitForMouseClick
correct:

mov word[x2], cx
mov word[y2], dx

push bx
mov bx, [boardsize]
sub bx, 1

mov ax, 0
mov al, bl
mul dl
add cx, dx
add ax, cx

pop bx

mov si, [selected]
cmp si, 0
jnz b ; 1st click storing part jump
mov word[t2], ax ; 1st click storing 
jmp c

b:
mov word[t3], ax ; 2nd click storing

c:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov si, [selected] ; moves the status of selected to si

cmp si, 0
jnz l2f

mov ax, [t2];;;; box number to ax
mov word[temp1], ax
mov word[selected], 1

mov cx, [x2]
mov dx, [y2]
mov word[x1], cx
mov word[y1], dx

mov word[redflag], 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; turning first click red
push cx
push dx

mov ax, 0xb800
mov es, ax
mov cx, [rx]
shr cx, 3
mov dx, [ry]
shr dx, 3

mov ax, 0
mov al, 80 ; load al with columns per row
mul dx ; multiply with y position
add ax, cx ; add x position
shl ax, 1
mov di, ax

jmp skipp
;;;;;;;;;;;;;;;;;;;
l2f:
jmp l2
;;;;;;;;;;;;;;;;;;;
skipp:

cmp word[es:di], 0x102D
je lower

lowerb:
cmp word[es:di], 0x107C
je right2

cmp word[es:di], 0x117C
je leftrightspace

simple:
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp nochange


lower:
add di, 160
jmp lowerb


right2:
add di, 4
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp nochange


leftrightspace:
add di, 2
cmp word[es:di], 0x107C
jne leftspace

rightspace:
sub di, 4
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp nochange

leftspace:
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430

nochange:

pop cx
pop dx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
jmp waitForMouseClick

l2:
cmp si, 1
jnz compare

mov ax, [t3];;;;
mov word[temp2], ax
mov word[selected], 2
mov ax, [t2];;;;
mov word[temp1], ax


compare:

mov cx, [temp1]
mov dx, [temp2]
cmp cx, dx  ;   checking if user clicks twice on the same block
jz incorrect1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si, cx
mov di, dx

shl si, 1
shl di, 1

cmp word[grid+si], 0xB058 ;   checking if user clicks on hurdles
jz incorrect1

cmp word[grid+di], 0xB058 ;   checking if user clicks on hurdles
jz incorrect1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call swapping

call printboard

;;;;;;;;;;;;;;;;;;;;;;;;
push ax
mov ax, [bombblast]
cmp ax, 1
je blast
;;;;;;;;;;;;;;;;;;;;;;;;

call removal
call removal
call removal
call removal
call removal
call removal

jmp noblast
;;;;;;;;;;;;;;;;;;;;;
blast:
call blastremoval
;;;;;;;;;;;;;;;;;;;;;
noblast:
pop ax

call delay

call printboard

;;;;;;;;;;;;;;;;;;;;;;
call hurdlescheck ; check if hurdles will be removed or not
;;;;;;;;;;;;;;;;;;;;;;

call fillspaces

call delay

call printboard

;;;;;;;;;;;;;;;;;;;;;;;;;;
mov word[bombblast], 0
;;;;;;;;;;;;;;;;;;;;;;;;;;

jmp avoid
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incorrect1:
call printboard
jmp incorrect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avoid:

mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [score] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits

nextdigit4: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit4 ; if no divide it again
mov di, 436 ; point di to top left column

nextpos4: pop dx ; remove a digit from the stack
mov dh, 0x40 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos4 ; repeat for all digits on stack


mov ax, [moves]
dec ax
mov word[moves], ax
cmp ax, 10
jb single

mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [moves] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits

nextdigit3: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit3 ; if no divide it again
mov di, 776 ; point di to top left column

nextpos3: pop dx ; remove a digit from the stack
mov dh, 0x40 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos3 ; repeat for all digits on stack
jmp skipsingle

single:
mov ah, 0x40
add al, 0x30
mov [es:776], ax
mov word[es:778], 0x4020

mov ax, [moves]
cmp ax, 0 ; zero ascii to end game
je dist

skipsingle:

;;;;;;;;;;;;

mov word[selected], 0

mov si, 0

jmp waitForMouseClick

incorrect:
mov word[selected], 0
call printboard

waitForMouseClick:

call delay

mov ax, 0001h ;to show mouse
int 33h
mov ax,0003h
int 33h
or bx,bx
jz short waitForMouseClick
mov ax, 0002h ;hide mouse after clicking

int 33h

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; saving click coordinates
mov word[rx], cx
mov word[ry], dx
;;;;;;;;;;;;;;;;;;;;;;;;;;;
shr cx, 5
shr dx, 4
;;;;;;;;;;;;;;

cmp word[redflag], 1
jne ignore
mov word[redflag], 0
call removeredhighlight

ignore:

mov word[temp1], cx
mov word[temp2], dx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

jmp avoid2
dist:
jmp gameover

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

avoid2:

mov cx, [temp1]
mov dx, [temp2]

;check mouse click coordinates [click should be inside the game play area]
cmp cx, [boardsize]
jb c2
jmp end

c2:
cmp dx,[boardsize]
jb correct

end:
jmp incorrect

gameover:

pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

play: ; starts the actual game and user input process
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

; click
call click ; input from user until out of moves


pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

introscreen:
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov cx, 2000 ; number of screen locations

cld ; auto increment mode
screen2:           
mov ax, 0x0120 ; space char in normal attribute
stosw
stosw
mov ax, 0x6F20 ; space char in normal attribute
stosw
stosw
loop screen2 ; clear the whole screen

;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si, longspace
mov ax, 0x0020
mov di, 1492
mov dx, 0

nextcharzl:
mov cx, [longspacelength]
nextcharz: ; printing 'player name string' on right side
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharz
add di, 100
inc dx
cmp dx, 3
jnz nextcharzl
;;;;;;;;;;;;;;;;;;;;;;;;;

mov si, intro
mov ah, 0x0E
mov di, 1662
mov cx, [lintro]

nextcharx: ; printing 'player name string' on right side
mov al, [si]
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharx


call longdelay

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


start: 
call clrscr
call introscreen
call clrscr ; call the clrscr subroutine
call username
call clrscr 

call boardvaluesloader

mov ax, pt 
push ax ; (bp+32)
mov ax, [lpt]
push ax ; (bp+30)
mov ax, 50
push ax ; push x position (bp+28)
mov ax, 1
push ax ; push y position (bp+26)
mov ax, 0x40 ; black on red attribute
push ax ; push atrribute red bg and black fg (bp+24)
mov ax, pn
push ax ; push player name string (bp+22)
mov ax, [lpn]
push ax ; push player name length(bp+20)
mov ax, ps
push ax ; push score string(bp+18)
mov ax, [lps]
push ax ; push score length(bp+16)
mov ax, 50
push ax ; push x position (bp+14)
mov ax, 1
push ax ; push y position (bp+12)
mov ax, 0x10 ; black on blue attribute
push ax ; push atrribute blue bg and black fg (bp+10)
mov ax, [m1]
push ax ; push '-' (bp+8)
mov ax, [m2]
push ax ; push '|' (bp+6)
mov ax, [m3]
push ax ; push 'space' (bp+4)

call initialize ; call the printstr subroutine (bp+2)

; lines after this will be executed once the initial board is printed
call play ; starts game

; lines after this will be executed once the game ends and user has run out of moves
call delay
call delay
call delay
call clrscr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

outro:
mov ax, 0xb800
mov es, ax ; point es to video base
xor di, di ; point di to top left column
mov cx, 2000 ; number of screen locations

cld ; auto increment mode
screen3:           
mov ax, 0x0120 ; space char in normal attribute
stosw
stosw
mov ax, 0x6F20 ; space char in normal attribute
stosw
stosw
loop screen3 ; clear the whole screen

;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si, longspace
mov ax, 0x0020
mov di, 1332
mov dx, 0

nextcharcl:
mov cx, [longspacelength]
nextcharc: ; printing 'player name string' on right side
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharc
add di, 100
inc dx
cmp dx, 7
jnz nextcharcl
;;;;;;;;;;;;;;;;;;;;;;;;;

mov si, gameovermsg
mov ah, 0x0E
mov di, 1512
mov cx, [lgo]

nextcharv: ; printing 'player name string' on right side
mov al, [si]
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharv

mov si, pn
mov ah, 0x0E
mov di, 1972
mov cx, [lpn]

nextcharb: ; printing 'player name string' on right side
mov al, [si]
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharb


mov di, 2000 ; starting index for screen printing user name
mov cx, 0 ; counter
mov ah, 0x0E
mov si, var1

nextcharn: ; printing
mov al, [si]; load next char of string
mov [es:di], ax ; show this char on screen
add di, 2 ; move to next screen location
inc si
inc cx
cmp cx, [length]
jne nextcharn


mov di, 2132 ; pointing to next line below player name where we will print player score
mov si, ps ; load adress for starting index of player score string
mov cx, [lps] ; initiallizing counter for player score string of length 7
mov ah, 0x0E

nextcharm: ; printing 'player score string' on right side
mov al, [si] ; load next char of string
mov [es:di], ax ; show this char on screen
inc si
add di, 2 ; move to next screen location
dec cx
jnz nextcharm


mov ax, [score] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits

nextdigitw: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigitw ; if no divide it again
mov di, 2148 ; point di to top left column

nextposw: pop dx ; remove a digit from the stack
mov dh, 0x0E ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextposw ; repeat for all digits on stack



mov ax, 0x4c00 ; terminate program
int 0x21





;;;;;;;;;;;;;;;; Made By:
;;;;;;;;;;;;;;;; Name: Moosa Imran
;;;;;;;;;;;;;;;; Roll No: 20L-0917
;;;;;;;;;;;;;;;; Section: BCS 3F
;;;;;;;;;;;;;;;; E-mail: l200917@lhr.nu.edu.pk