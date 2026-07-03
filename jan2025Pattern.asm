; ============================================================
; January 2025 CSE 316 - Hash + Number Pattern
; Input: n (0 < n < 10)
;
; n=3:          n=4:
; ###1          ####1
; ##12          ###12
; #123          ##123
;               #1234
;
; Row i: (n-i+1) times '#', then digits 1 to i
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- Read n from user (single digit 1-9) ----
    MOV AH, 01H
    INT 21H
    SUB AL, '0'              ; AL = n
    MOV DH, AL               ; DH keeps n safe (not touched by INT 21H print)

    MOV BX, 1                ; BX = current row (1 to n)

ROW_LOOP:
    ; ---- Print (n - row + 1) hash symbols ----
    MOV AX, DH               ; AX = n
    SUB AX, BX               ; AX = n - row
    INC AX                   ; AX = n - row + 1  (hash count)
    MOV CX, AX

HASH_LOOP:
    MOV DL, '#'
    MOV AH, 02H
    INT 21H
    LOOP HASH_LOOP

    ; ---- Print numbers 1 to row (1, 12, 123, ...) ----
    MOV CX, 1                ; CX = current column / digit

NUM_LOOP:
    MOV AL, CL               ; digit value (1..row)
    ADD AL, '0'              ; convert to ASCII '1'..'9'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    INC CX
    CMP CX, BX               ; more digits this row?
    JLE NUM_LOOP

    ; ---- Newline after row ----
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    INT 21H

    INC BX                   ; next row
    CMP BL, DH               ; row <= n ?
    JLE ROW_LOOP

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
