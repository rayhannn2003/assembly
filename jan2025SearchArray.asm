; ============================================================
; January 2025 CSE 316 (A2) - Count occurrences in array
;
; 1. Read array size (single digit)
; 2. Read array elements (single digits, space-separated)
; 3. Read value to search
; 4. Print how many times it appears (0 if not found)
;
; Example:
;   Input: 5 / 1 3 5 2 9 / 6  -> Output: 0
;   Input: 9 / 1 3 5 9 3 7 5 9 2 / 5 -> Output: 2
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    ARR_SIZE   DB ?
    ARRAY      DB 9 DUP(0)      ; max 9 elements (size is single digit)
    SEARCH_VAL DB ?
    MATCH_CNT  DB 0

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Read array size (single digit) ----
    CALL READ_DIGIT
    MOV ARR_SIZE, AL

    ; ---- MODULE: Read array elements (skip spaces) ----
    XOR BH, BH               ; BH = 0 (elements read so far)
    MOV BL, ARR_SIZE         ; BL = total elements needed
    MOV SI, OFFSET ARRAY

READ_ELEM_LOOP:
    CMP BH, BL
    JGE ELEMENTS_DONE

    CALL READ_DIGIT          ; AL = one digit (skips space / Enter)
    MOV [SI], AL
    INC SI
    INC BH
    JMP READ_ELEM_LOOP

ELEMENTS_DONE:

    ; ---- MODULE: Read search value (single digit) ----
    CALL READ_DIGIT
    MOV SEARCH_VAL, AL

    ; ---- MODULE: Count how many times value appears in array ----
    MOV SI, OFFSET ARRAY
    MOV CL, ARR_SIZE
    MOV CH, 0                ; CX = array size
    MOV AL, SEARCH_VAL
    CALL COUNT_VALUE_IN_ARRAY
    MOV MATCH_CNT, AL

    ; ---- MODULE: Print count as single digit ----
    MOV AL, MATCH_CNT
    CALL PRINT_DIGIT

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Read one digit from user (skips space and Enter) ----
; Returns: AL = numeric value 0-9
READ_DIGIT PROC
    PUSH BX

RD_LOOP:
    MOV AH, 01H
    INT 21H

    CMP AL, ' '
    JE  RD_LOOP
    CMP AL, 0DH
    JE  RD_LOOP
    CMP AL, 0AH
    JE  RD_LOOP

    SUB AL, '0'              ; ASCII to number

    POP BX
    RET
READ_DIGIT ENDP


; ---- MODULE: Print single digit 0-9 ----
; Input:  AL = digit value
PRINT_DIGIT PROC
    PUSH AX
    PUSH DX

    ADD AL, '0'              ; number to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    POP DX
    POP AX
    RET
PRINT_DIGIT ENDP


; ---- MODULE: Count occurrences of AL in byte array ----
; Input:  SI = array offset, CX = size, AL = value to find
; Returns: AL = count
COUNT_VALUE_IN_ARRAY PROC
    PUSH BX
    PUSH CX
    PUSH SI

    MOV BL, 0                ; BL = match counter

CVIA_LOOP:
    CMP [SI], AL
    JNE CVIA_NEXT
    INC BL

CVIA_NEXT:
    INC SI
    LOOP CVIA_LOOP

    MOV AL, BL               ; return count in AL

    POP SI
    POP CX
    POP BX
    RET
COUNT_VALUE_IN_ARRAY ENDP

END MAIN
