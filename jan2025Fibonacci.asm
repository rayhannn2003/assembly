; ============================================================
; January 2025 CSE 316 (C1) - n-th Fibonacci (recursive)
;
; F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)
; Input: n from user (single digit, 0 < n < 10)
; Output: F(n) printed to console
;
; Case 1: n=3 -> 2
; Case 2: n=7 -> 13
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Read n (single digit) ----
    MOV AH, 01H
    INT 21H
    SUB AL, '0'              ; AL = n
    MOV AH, 0                ; AX = n

    ; ---- Call recursive Fibonacci ----
    CALL FIB                 ; AX = F(n)

    ; ---- MODULE: Print number (may be 1 or 2 digits) ----
    MOV BX, 10
    XOR DX, DX
    DIV BX                   ; AX = tens, DX = ones

    CMP AX, 0
    JE  PRINT_ONES

    ; print tens digit
    PUSH DX                  ; save ones
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    POP DX                   ; restore ones

PRINT_ONES:
    ADD DL, '0'
    MOV AH, 02H
    INT 21H

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Recursive Fibonacci ----
; Input:  AX = n  (n >= 0)
; Output: AX = F(n)
;
; F(0) = 0
; F(1) = 1
; F(n) = F(n-1) + F(n-2)
FIB PROC

    CMP AX, 0
    JE  FIB_ZERO
    CMP AX, 1
    JE  FIB_ONE

    PUSH BX
    PUSH AX                  ; save n on stack

    DEC AX                   ; n - 1
    CALL FIB
    MOV BX, AX               ; BX = F(n-1)

    POP AX                   ; restore n
    PUSH BX                  ; save F(n-1)

    SUB AX, 2                ; n - 2
    CALL FIB                 ; AX = F(n-2)

    POP BX                   ; BX = F(n-1)
    ADD AX, BX               ; F(n-2) + F(n-1)

    POP BX
    RET

FIB_ZERO:
    MOV AX, 0
    RET

FIB_ONE:
    MOV AX, 1
    RET

FIB ENDP

END MAIN
