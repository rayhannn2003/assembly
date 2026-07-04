; ============================================================
; January 2025 CSE 316 (B2) - Sum of digits (recursive)
;
; Recursive function: sum of digits of n
; No user input. No need to print result (sum ends in AX).
; Assume 0 < n < 65535
;
; Case 1: n = 253   -> sum = 2+5+3 = 10
; Case 2: n = 23126 -> sum = 2+3+1+2+6 = 14
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    N DW 253                 ; Case 1
    ; N DW 23126             ; Case 2

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Call recursive function with n in AX ----
    MOV AX, N
    CALL SUM_DIGITS          ; result in AX when done

    ; AX now holds sum (10 for n=253, 14 for n=23126)
    ; No printing required by the question

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Recursive sum of digits ----
; Input:  AX = n  (0 <= n <= 65535)
; Output: AX = sum of digits of n
;
; Logic:
;   if n == 0  -> return 0
;   else       -> return (n % 10) + SUM_DIGITS(n / 10)
SUM_DIGITS PROC

    CMP AX, 0
    JE  SUM_ZERO

    PUSH BX

    MOV BX, 10
    XOR DX, DX
    DIV BX                   ; AX = n / 10,  DX = n % 10

    PUSH DX                  ; save last digit on stack

    CALL SUM_DIGITS          ; AX = sum of digits of (n / 10)

    POP DX                   ; restore last digit
    ADD AX, DX               ; add last digit to recursive sum

    POP BX
    RET

SUM_ZERO:
    MOV AX, 0
    RET

SUM_DIGITS ENDP

END MAIN
