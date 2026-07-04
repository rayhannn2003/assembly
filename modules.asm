; ================================================================
; modules.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste any module below into your real program when needed.
; ================================================================


; ================================================================
; MODULE: Init Data Segment
; Use at the start of MAIN in every program.
; ================================================================
;
;    MOV AX, @DATA
;    MOV DS, AX
;


; ================================================================
; MODULE: Exit Program
; Use at the end of MAIN in every program.
; ================================================================
;
;    MOV AH, 4CH
;    INT 21H
;


; ================================================================
; MODULE: Print one character
; Set DL = character, then run these two lines.
; ================================================================
;
;    MOV AH, 02H
;    INT 21H
;


; ================================================================
; MODULE: Print string
; String must end with '$'. Set DX = OFFSET of string.
; ================================================================
;
;    MOV AH, 09H
;    INT 21H
;
; Or as a procedure (paste before END MAIN):
;
; PRINT_STRING PROC
;     MOV AH, 09H
;     INT 21H
;     RET
; PRINT_STRING ENDP
;
; Usage:  MOV DX, OFFSET MSG
;         CALL PRINT_STRING
;


; ================================================================
; MODULE: Print newline (CR + LF)
; ================================================================
;
;    MOV DL, 0DH
;    MOV AH, 02H
;    INT 21H
;    MOV DL, 0AH
;    MOV AH, 02H
;    INT 21H
;


; ================================================================
; MODULE: Read one character (echoed, result in AL)
; ================================================================
;
;    MOV AH, 01H
;    INT 21H
;


; ================================================================
; MODULE: Read until Enter (CR = 0DH)
; Keeps reading until user presses Enter.
; ================================================================
;
;    MOV AH, 01H
; READ_UNTIL_CR:
;     INT 21H
;     CMP AL, 0DH
;     JNE READ_UNTIL_CR
;


; ================================================================
; MODULE: Read until Space (20H)
; Keeps reading until user presses Space.
; ================================================================
;
;    MOV AH, 01H
; READ_UNTIL_SPACE:
;     INT 21H
;     CMP AL, 20H
;     JNE READ_UNTIL_SPACE
;


; ================================================================
; MODULE: Count characters until Enter (count in DX, Enter not counted)
; ================================================================
;
;    MOV DX, 0
;    MOV AH, 01H
;    INT 21H
; COUNT_UNTIL_CR:
;     CMP AL, 0DH
;     JE  COUNT_DONE
;     INC DX
;     INT 21H
;     JMP COUNT_UNTIL_CR
; COUNT_DONE:
;


; ================================================================
; MODULE: Print byte array (DB) using a loop
; SI = OFFSET array,  CX = number of bytes
; ================================================================
;
;    MOV SI, OFFSET MY_ARRAY
;    MOV CX, ARRAY_SIZE
; PRINT_BYTE_LOOP:
;     MOV DL, [SI]
;     MOV AH, 02H
;     INT 21H
;     INC SI
;     LOOP PRINT_BYTE_LOOP
;


; ================================================================
; MODULE: Declare byte array (string)
; ================================================================
;
;    MY_ARRAY DB 'Hello World', 0DH, 0AH
;    ARRAY_SIZE EQU $ - MY_ARRAY
;


; ================================================================
; MODULE: Declare word array (numbers)
; ================================================================
;
;    MY_ARRAY DW 10, 20, 30, 40
;    ARR_WORDS EQU ($ - MY_ARRAY) / 2
;


; ================================================================
; MODULE: Check word array order (asc / desc / not sorted)
; BX=1 ascending, DX=1 descending. Change MY_ARRAY / ARR_WORDS for your data.
; ================================================================
;
;    MOV BX, 1
;    MOV DX, 1
;    MOV CX, ARR_WORDS
;    CMP CX, 1
;    JBE SORT_DONE
;    DEC CX
;    MOV SI, OFFSET MY_ARRAY
; SORT_CHECK_LOOP:
;     MOV AX, [SI]
;     MOV DI, [SI+2]
;     CMP DI, AX
;     JB  SORT_NOT_ASC
;     JA  SORT_NOT_DESC
;     JMP SORT_NEXT
; SORT_NOT_ASC:
;     MOV BX, 0
;     JMP SORT_NEXT
; SORT_NOT_DESC:
;     MOV DX, 0
; SORT_NEXT:
;     ADD SI, 2
;     LOOP SORT_CHECK_LOOP
; SORT_DONE:
;     ; BX=1 -> ascending,  DX=1 -> descending,  else not sorted
;


; ================================================================
; MODULE: Print N times with LOOP (e.g. 80 stars)
; ================================================================
;
;    MOV CX, 80
; REPEAT_N:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP REPEAT_N
;


; ================================================================
; MODULE: Nested loop - square pattern (n rows, n '#' per row)
; Reads n from keyboard (single digit '1'-'9'), prints n x n grid.
; IMPORTANT: LOOP uses CX. Inner loop destroys CX, so save outer
;            count on stack with PUSH/POP before inner LOOP.
; ================================================================
;
;    ; Read n from user
;    MOV AH, 01H
;    INT 21H
;    SUB AL, '0'              ; AL = n
;    MOV AH, 0
;    MOV BX, AX               ; BX = outer row counter
;
;    ; Newline after input
;    MOV DL, 0DH
;    MOV AH, 02H
;    INT 21H
;    MOV DL, 0AH
;    INT 21H
;
; OUTER_LOOP:
;     PUSH BX                  ; save outer counter (CX will be used inside)
;     MOV CX, BX               ; inner loop: print BX times per row
;
; INNER_LOOP:
;     MOV DL, '#'
;     MOV AH, 02H
;     INT 21H
;     LOOP INNER_LOOP
;
;     POP BX                   ; restore outer counter
;
;     ; Newline after each row
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     DEC BX
;     JNZ OUTER_LOOP
;
; Example output for n=3:
; ###
; ###
; ###
;


; ================================================================
; MODULE: Nested loop - generic template (rows x cols)
; BX = number of rows,  CX = number of columns per row
; Use DEC/JNZ for outer loop (so inner loop can freely use CX + LOOP)
; ================================================================
;
;    MOV BX, 4                ; 4 rows
;
; OUTER_ROW:
;     MOV CX, 5              ; 5 columns per row
;
; INNER_COL:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP INNER_COL
;
;     ; newline after row
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     DEC BX
;     JNZ OUTER_ROW
;
; Example output:
; *****
; *****
; *****
; *****
;


; ================================================================
; MODULE: Nested loop - save CX on stack (outer LOOP + inner LOOP)
; Use when BOTH loops use LOOP instruction.
; WARNING: Store n in BX (not AX). INT 21H destroys AX each call!
; ================================================================
;
;    MOV AH, 01H
;     INT 21H
;     SUB AL, '0'
;     MOV AH, 0
;     MOV BX, AX               ; BX keeps n safe for entire program
;
;     MOV CX, BX               ; outer count
;
; OUTER_LOOP:
;     PUSH CX
;     MOV CX, BX               ; inner count from BX (NOT AX)
;
; INNER_LOOP:
;     MOV DL, '#'
;     MOV AH, 02H
;     INT 21H
;     LOOP INNER_LOOP
;
;     ; newline ...
;
;     POP CX
;     LOOP OUTER_LOOP
;
; Example: n=3 prints 3 rows of 3 '#' each.
;


; ================================================================
; PATTERN 1: Right triangle (ascending stars)
; *
; **
; ***
; ****
; BX = row (1 to n). Inner stars = row number.
; ================================================================
;
;    MOV DH, 4                ; n = 4 rows (keep n in DH, not DL)
;    MOV BX, 1                ; current row
;
; PAT1_ROW:
;     MOV CX, BX               ; print BX stars this row
; PAT1_STAR:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP PAT1_STAR
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     MOV AL, DH
;     INC AL                   ; n+1
;     CMP BL, AL
;     JLE PAT1_ROW
;


; ================================================================
; PATTERN 2: Right triangle (descending stars)
; ****
; ***
; **
; *
; Start with n stars, decrease by 1 each row.
; ================================================================
;
;    MOV BX, 4                ; BX = stars this row (starts at n)
;
; PAT2_ROW:
;     MOV CX, BX
; PAT2_STAR:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP PAT2_STAR
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     DEC BX
;     JNZ PAT2_ROW
;


; ================================================================
; PATTERN 3: Odd-count triangle (1, 3, 5, 7 ... stars per row)
; *
; ***
; *****
; BX = row number. Stars per row = 2*BX - 1
; ================================================================
;
;    MOV BX, 1                ; row number
;    MOV DH, 3                ; n = 3 rows (save n in DH)
;
; PAT3_ROW:
;     MOV AX, BX
;     SHL AX, 1                ; AX = 2 * row
;     DEC AX                   ; AX = 2*row - 1  (stars this row)
;     MOV CX, AX
;
; PAT3_STAR:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP PAT3_STAR
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     CMP BX, 4                ; n+1  (change if n=3)
;     JLE PAT3_ROW
;
; Alternate: keep star count in CX, add 2 each row (1, 3, 5...)
;    MOV CX, 1
; PAT3_ROW:
;     PUSH CX
;     PAT3_STAR: ... LOOP PAT3_STAR
;     POP CX
;     ADD CX, 2
;     CMP CX, 8                ; stop after 7? or count rows separately
;


; ================================================================
; PATTERN 4: Number triangle
; 1
; 1 2
; 1 2 3
; 1 2 3 4
; BX = current row, inner loop CX = 1 to BX
; ================================================================
;
;    MOV BX, 1                ; current row
;    MOV DH, 4                ; n = 4 rows
;
; PAT4_ROW:
;     MOV CX, 1                ; current column
;
; PAT4_COL:
;     MOV AL, CL               ; number to print (1..row)
;     ADD AL, '0'              ; convert to ASCII digit
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;
;     MOV DL, ' '              ; space between numbers
;     MOV AH, 02H
;     INT 21H
;
;     INC CX
;     CMP CX, BX               ; column <= row ?
;     JLE PAT4_COL
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     CMP BX, 5                ; n+1
;     JLE PAT4_ROW
;


; ================================================================
; PATTERN 5: Right-aligned star pyramid (spaces + stars)
;     *
;    **
;   ***
;  ****
; *****
; Row i: print (n-i) spaces, then i stars
; WARNING: if CX=0, LOOP runs 65536 times! Skip space loop when CX=0.
; ================================================================
;
;    MOV DH, 5                ; n = 5 rows
;    MOV BX, 1                ; current row
;
; PAT5_ROW:
;     ; --- print leading spaces: (n - row) ---
;     MOV AX, DH               ; AX = n
;     SUB AX, BX               ; AX = spaces = n - row
;     MOV CX, AX
;     CMP CX, 0
;     JE  PAT5_STARS
;
; PAT5_SPACE:
;     MOV DL, ' '
;     MOV AH, 02H
;     INT 21H
;     LOOP PAT5_SPACE
;
; PAT5_STARS:
;     MOV CX, BX               ; print BX stars
; PAT5_STAR:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP PAT5_STAR
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     MOV AL, DH
;     INC AL
;     CMP BL, AL
;     JLE PAT5_ROW
;


; ================================================================
; MODULE: Read one digit (skips space, Enter, newline)
; Returns digit 0-9 in AL. Paste procedure before END MAIN.
; ================================================================
;
; READ_DIGIT PROC
;     PUSH BX
; RD_LOOP:
;     MOV AH, 01H
;     INT 21H
;     CMP AL, ' '
;     JE  RD_LOOP
;     CMP AL, 0DH
;     JE  RD_LOOP
;     CMP AL, 0AH
;     JE  RD_LOOP
;     SUB AL, '0'
;     POP BX
;     RET
; READ_DIGIT ENDP
;


; ================================================================
; MODULE: Print single digit (0-9)
; Input: AL = digit value
; ================================================================
;
; PRINT_DIGIT PROC
;     PUSH AX
;     PUSH DX
;     ADD AL, '0'
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;     POP DX
;     POP AX
;     RET
; PRINT_DIGIT ENDP
;


; ================================================================
; MODULE: Read byte array of single digits (skip spaces)
; ARR_SIZE already set. Stores into ARRAY.
; ================================================================
;
;    XOR BH, BH
;    MOV BL, ARR_SIZE
;    MOV SI, OFFSET ARRAY
; READ_ELEM_LOOP:
;     CMP BH, BL
;     JGE ELEMENTS_DONE
;     CALL READ_DIGIT
;     MOV [SI], AL
;     INC SI
;     INC BH
;     JMP READ_ELEM_LOOP
; ELEMENTS_DONE:
;


; ================================================================
; MODULE: Count how many times AL appears in byte array
; Input: SI = array, CX = size, AL = value to find
; Returns: AL = count
; ================================================================
;
; COUNT_VALUE_IN_ARRAY PROC
;     PUSH BX
;     PUSH CX
;     PUSH SI
;     MOV BL, 0
; CVIA_LOOP:
;     CMP [SI], AL
;     JNE CVIA_NEXT
;     INC BL
; CVIA_NEXT:
;     INC SI
;     LOOP CVIA_LOOP
;     MOV AL, BL
;     POP SI
;     POP CX
;     POP BX
;     RET
; COUNT_VALUE_IN_ARRAY ENDP
;


; ================================================================
; MODULE: Leap year detection (function / procedure)
;
; Rules:
;   Leap if divisible by 4
;   NOT leap if divisible by 100
;   Leap again if divisible by 400
;
; Examples: 2024=leap, 2000=leap, 1900=not leap, 2023=not leap
;
; Input:  AX = year (e.g. 2024)
; Output: AL = 1 if leap year, AL = 0 if not
;
; Usage in MAIN:
;    MOV AX, 2024
;    CALL IS_LEAP_YEAR       ; AL = 1 or 0
; ================================================================
;
; IS_LEAP_YEAR PROC
;     PUSH BX
;     PUSH CX
;     PUSH DX
;
;     MOV CX, AX               ; CX keeps year (AX changes after DIV)
;
;     ; year % 400 == 0 ?
;     MOV AX, CX
;     XOR DX, DX
;     MOV BX, 400
;     DIV BX
;     CMP DX, 0
;     JE  LY_YES
;
;     ; year % 100 == 0 ?
;     MOV AX, CX
;     XOR DX, DX
;     MOV BX, 100
;     DIV BX
;     CMP DX, 0
;     JE  LY_NO
;
;     ; year % 4 == 0 ?
;     MOV AX, CX
;     XOR DX, DX
;     MOV BX, 4
;     DIV BX
;     CMP DX, 0
;     JE  LY_YES
;
;     JMP LY_NO
;
; LY_YES:
;     MOV AL, 1
;     JMP LY_DONE
;
; LY_NO:
;     MOV AL, 0
;
; LY_DONE:
;     POP DX
;     POP CX
;     POP BX
;     RET
; IS_LEAP_YEAR ENDP
;

