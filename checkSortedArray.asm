.MODEL SMALL
.STACK 100H

.DATA
    ; Case 1: ascending
    MY_ARRAY DW 10, 20, 20, 30, 40, 50, 60, 70, 76, 80, 80, 100, 110, 120, 120, 120, 130
    ; Case 2: DW 60, 50, 40, 40, 30, 20, 15, 1, 0
    ; Case 3: DW 10, 20, 30, 25, 40

    ARR_WORDS EQU ($ - MY_ARRAY) / 2

    MSG_ASC  DB 'Ascending$'
    MSG_DESC DB 'Descending$'
    MSG_NS   DB 'Not sorted$'

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Check word array order (ascending / descending / not sorted) ----
    ; BX = 1 if ascending,  DX = 1 if descending
    MOV BX, 1
    MOV DX, 1

    MOV CX, ARR_WORDS
    CMP CX, 1
    JBE PRINT_RESULT              ; 0 or 1 element -> sorted

    DEC CX                        ; compare (count - 1) pairs
    MOV SI, OFFSET MY_ARRAY

CHECK_LOOP:
    MOV AX, [SI]                  ; current word
    MOV DI, [SI+2]                ; next word

    CMP DI, AX
    JB  NOT_ASCENDING             ; next < current
    JA  NOT_DESCENDING            ; next > current
    JMP NEXT_PAIR

NOT_ASCENDING:
    MOV BX, 0
    JMP NEXT_PAIR

NOT_DESCENDING:
    MOV DX, 0

NEXT_PAIR:
    ADD SI, 2
    LOOP CHECK_LOOP

    ; ---- MODULE: Print result message ----
PRINT_RESULT:
    CMP BX, 1
    JNE CHECK_DESC

    MOV DX, OFFSET MSG_ASC
    CALL PRINT_STRING
    JMP DONE

CHECK_DESC:
    CMP DX, 1
    JNE PRINT_NOT_SORTED

    MOV DX, OFFSET MSG_DESC
    CALL PRINT_STRING
    JMP DONE

PRINT_NOT_SORTED:
    MOV DX, OFFSET MSG_NS
    CALL PRINT_STRING

DONE:

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Print string (DX = offset, string ends with '$') ----
PRINT_STRING PROC
    MOV AH, 09H
    INT 21H
    RET
PRINT_STRING ENDP

END MAIN
