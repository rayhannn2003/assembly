; ============================================================
; January 2025 CSE 316 (B1) - Second highest in array
;
; Array of 10 distinct elements, 0 < e < 16
; No user input. Display the second highest value.
;
; Case 1: 1 3 10 12 4 6 2 9 7 11  -> Output: 11
; Case 2: 4 2 7 15 1 9 3 6 10 13  -> Output: 13
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    ; Case 1
    MY_ARRAY DB 1, 3, 10, 12, 4, 6, 2, 9, 7, 11
    ; Case 2: DB 4, 2, 7, 15, 1, 9, 3, 6, 10, 13

    ARR_SIZE EQU 10

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Find highest and second highest (single pass) ----
    ; BL = highest,  DL = second highest
    MOV SI, OFFSET MY_ARRAY
    MOV BL, [SI]             ; highest = first element
    MOV DL, 0                ; second highest
    INC SI
    MOV CX, ARR_SIZE
    DEC CX                   ; remaining 9 elements

SCAN_LOOP:
    MOV AL, [SI]

    CMP AL, BL
    JG  NEW_HIGHEST          ; found new max

    CMP AL, DL
    JLE SCAN_NEXT            ; not greater than second max
    MOV DL, AL               ; update second highest
    JMP SCAN_NEXT

NEW_HIGHEST:
    MOV DL, BL               ; old max becomes second max
    MOV BL, AL               ; new max

SCAN_NEXT:
    INC SI
    LOOP SCAN_LOOP

    ; ---- MODULE: Print number 1-15 (DL = second highest) ----
    MOV AX, 0
    MOV AL, DL               ; AL = value to print
    MOV BL, 10
    DIV BL                   ; AL = tens, AH = ones

    CMP AL, 0
    JE  PRINT_ONES           ; single digit (1-9)

    ; print tens digit
    PUSH AX                  ; save ones in AH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    POP AX                   ; restore, AH = ones
    MOV AL, AH

PRINT_ONES:
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
