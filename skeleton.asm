.MODEL SMALL
.STACK 100H

.DATA
    ; declare arrays, messages, variables here

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment (copy into every program) ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- YOUR CODE HERE ----


    ; ---- MODULE: Exit Program (copy into every program) ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
