; ============================================================
; Leap year detection - demo
; Change YEAR to test: 2024, 2000, 1900, 2023
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    YEAR DW 2024

    MSG_LEAP DB 'Leap Year$'
    MSG_NOT  DB 'Not Leap Year$'

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Check leap year ----
    MOV AX, YEAR
    CALL IS_LEAP_YEAR        ; AL = 1 leap, 0 not leap

    CMP AL, 1
    JE  SHOW_LEAP

    MOV DX, OFFSET MSG_NOT
    JMP PRINT_MSG

SHOW_LEAP:
    MOV DX, OFFSET MSG_LEAP

PRINT_MSG:
    MOV AH, 09H
    INT 21H

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Leap year detection ----
; Input:  AX = year
; Output: AL = 1 (leap) or 0 (not leap)
IS_LEAP_YEAR PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, AX               ; save year in CX

    ; year % 400 == 0 ?
    MOV AX, CX
    XOR DX, DX
    MOV BX, 400
    DIV BX
    CMP DX, 0
    JE  LY_YES

    ; year % 100 == 0 ?
    MOV AX, CX
    XOR DX, DX
    MOV BX, 100
    DIV BX
    CMP DX, 0
    JE  LY_NO

    ; year % 4 == 0 ?
    MOV AX, CX
    XOR DX, DX
    MOV BX, 4
    DIV BX
    CMP DX, 0
    JE  LY_YES

    JMP LY_NO

LY_YES:
    MOV AL, 1
    JMP LY_DONE

LY_NO:
    MOV AL, 0

LY_DONE:
    POP DX
    POP CX
    POP BX
    RET
IS_LEAP_YEAR ENDP

END MAIN
