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

    ; Read n from user
    MOV AH, 01H
    INT 21H
    SUB AL, '0'              ; AL = n
    MOV AH, 0
    MOV BX, AX               ; BX = n  (SAVE n here! never use AX again for n)

    ; Newline after input
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    INT 21H

    MOV CX, BX               ; outer count = n

OUTER_LOOP:
    PUSH CX                  ; save outer CX

    MOV CX, BX               ; inner count = n  (use BX, NOT AX)

INNER_LOOP:
    MOV DL, '#'
    MOV AH, 02H
    INT 21H
    LOOP INNER_LOOP

    ; newline after row
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    INT 21H

    POP CX                   ; restore outer CX
    LOOP OUTER_LOOP

    ; ---- MODULE: Exit Program (copy into every program) ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
