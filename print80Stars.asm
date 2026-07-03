.MODEL SMALL
.STACK 100H

.DATA

.CODE
MAIN PROC

    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Print 80 stars
    MOV CX, 80          ; Loop counter

PRINT_STAR:
    MOV DL, '*'         ; Character to print
    MOV AH, 02H         ; DOS function: Display character
    INT 21H

    LOOP PRINT_STAR

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN