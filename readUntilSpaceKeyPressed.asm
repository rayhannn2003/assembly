.MODEL SMALL
.STACK 100H

.DATA

.CODE
MAIN PROC

    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Your code goes here
 MOV AH, 1 ; read char function
REPEAT:
INT 21h ; read a char in AL
CMP AL, 20h ; a blank?
JNE REPEAT ; no, keep reading

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN