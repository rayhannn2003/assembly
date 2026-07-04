; ============================================================
; January 2025 CSE 316 (A2) - Count occurrences in array
; ALTERNATIVE: all inline in MAIN (no procedures)
;
; Same problem as jan2025SearchArray.asm
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    ARR_SIZE   DB ?
    ARRAY      DB 9 DUP(0)
    SEARCH_VAL DB ?
    MATCH_CNT  DB 0

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Read array size (single digit, skip space/Enter) ----
READ_SIZE:
    MOV AH, 01H
    INT 21H
    CMP AL, ' '
    JE  READ_SIZE
    CMP AL, 0DH
    JE  READ_SIZE
    CMP AL, 0AH
    JE  READ_SIZE
    SUB AL, '0'
    MOV ARR_SIZE, AL

    ; ---- MODULE: Read array elements (skip spaces) ----
    XOR BH, BH               ; elements read so far
    MOV BL, ARR_SIZE         ; total needed
    MOV SI, OFFSET ARRAY

READ_ELEM_LOOP:
    CMP BH, BL
    JGE ELEMENTS_DONE

READ_ONE_ELEM:
    MOV AH, 01H
    INT 21H
    CMP AL, ' '
    JE  READ_ONE_ELEM
    CMP AL, 0DH
    JE  READ_ONE_ELEM
    CMP AL, 0AH
    JE  READ_ONE_ELEM
    SUB AL, '0'
    MOV [SI], AL
    INC SI
    INC BH
    JMP READ_ELEM_LOOP

ELEMENTS_DONE:

    ; ---- MODULE: Read search value (single digit) ----
READ_SEARCH:
    MOV AH, 01H
    INT 21H
    CMP AL, ' '
    JE  READ_SEARCH
    CMP AL, 0DH
    JE  READ_SEARCH
    CMP AL, 0AH
    JE  READ_SEARCH
    SUB AL, '0'
    MOV SEARCH_VAL, AL

    ; ---- MODULE: Count how many times value appears in array ----
    MOV SI, OFFSET ARRAY
    MOV CL, ARR_SIZE
    MOV CH, 0                ; CX = array size
    MOV BL, 0                ; BL = match counter
    MOV AL, SEARCH_VAL

COUNT_LOOP:
    CMP [SI], AL
    JNE COUNT_NEXT
    INC BL

COUNT_NEXT:
    INC SI
    LOOP COUNT_LOOP

    MOV MATCH_CNT, BL

    ; ---- MODULE: Print count as single digit ----
    MOV AL, MATCH_CNT
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
