; ============================================================
; January 2025 CSE 316 (C2) - Reverse array in-place
;
; Size = 8 (hardcoded). No extra array. Print reversed array.
; Elements: 0-14 (single or double digit)
;
; Case 1: 1 3 5 2 9 2 3 10  ->  10 3 2 9 2 5 3 1
; Case 2: 3 3 5 9 11 7 2 9  ->  9 2 7 11 9 5 3 3
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    ; Case 1
    MY_ARRAY DB 1, 3, 5, 2, 9, 2, 3, 10
    ; Case 2: DB 3, 3, 5, 9, 11, 7, 2, 9

    ARR_SIZE EQU 8

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Reverse array in-place (two pointers) ----
    ; SI -> start,  DI -> end,  swap and move inward
    MOV SI, OFFSET MY_ARRAY
    MOV DI, OFFSET MY_ARRAY
    ADD DI, ARR_SIZE
    DEC DI                   ; DI points to last element

    MOV CX, ARR_SIZE
    SHR CX, 1                ; CX = number of swaps = size / 2

SWAP_LOOP:
    MOV AL, [SI]             ; temp = arr[start]
    MOV BL, [DI]
    MOV [SI], BL             ; arr[start] = arr[end]
    MOV [DI], AL             ; arr[end] = temp

    INC SI
    DEC DI
    LOOP SWAP_LOOP

    ; ---- MODULE: Print reversed array (numbers + space) ----
    MOV SI, OFFSET MY_ARRAY
    MOV CX, ARR_SIZE

PRINT_LOOP:
    MOV AL, [SI]             ; current element (0-14)

    ; print number (1 or 2 digits)
    MOV AH, 0
    MOV BL, 10
    DIV BL                   ; AL = tens, AH = ones

    OR  AL, AL
    JZ  PRINT_ONES_ONLY      ; single digit: ones in AH

    PUSH AX                  ; save ones in AH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    POP AX

PRINT_ONES_ONLY:
    MOV AL, AH               ; ones digit (also used when < 10)
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ; print space after each element
    MOV DL, ' '
    MOV AH, 02H
    INT 21H

    INC SI
    LOOP PRINT_LOOP

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
