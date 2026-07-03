.MODEL SMALL
.STACK 100H

.DATA
    MY_ARRAY DW '10','20','30','40'
    WORD_COUNT EQU 4

.CODE


MAIN PROC

    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Print array using a loop
      MOV SI, OFFSET MY_ARRAY
    MOV CX, WORD_COUNT        ; 4 words, not 8 bytes

PRINT_LOOP:
    MOV DL, [SI]              ; 1st char of word ('1', '2', ...)
    MOV AH, 02H
    INT 21H

    MOV DL, [SI+1]            ; 2nd char ('0')
    MOV AH, 02H
    INT 21H

    MOV DL, 20H               ; space after each number
    MOV AH, 02H
    INT 21H

    ADD SI, 2                 ; next WORD (2 bytes)
    LOOP PRINT_LOOP

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
