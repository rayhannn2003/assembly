
; ================================================================
; INPUT 1: Read one character (any key, echoed)
; Result in AL
; ================================================================
;
;    MOV AH, 01H
;    INT 21H                  ; AL = character typed
;
; Or as procedure:
;
; READ_CHAR PROC
;     MOV AH, 01H
;     INT 21H
;     RET
; READ_CHAR ENDP
;


; ================================================================
; INPUT 2: Read one digit (0-9), skip space and Enter
; Result in AL as NUMBER (not ASCII)
; Uses branching loop to ignore unwanted keys
; ================================================================
;
; READ_DIGIT PROC
; RD_LOOP:
;     MOV AH, 01H
;     INT 21H
;     CMP AL, ' '
;     JE  RD_LOOP
;     CMP AL, 0DH
;     JE  RD_LOOP
;     CMP AL, 0AH
;     JE  RD_LOOP
;     SUB AL, '0'              ; ASCII -> number
;     RET
; READ_DIGIT ENDP
;
; Usage:  CALL READ_DIGIT
;         ; AL = 0..9
;


; ================================================================
; INPUT 3: Read until Enter (keeps reading, discards chars)
; Good for "press any keys until Enter" problems
; ================================================================
;
;    MOV AH, 01H
; READ_UNTIL_CR:
;     INT 21H
;     CMP AL, 0DH
;     JNE READ_UNTIL_CR
;


; ================================================================
; INPUT 4: Read until Space
; ================================================================
;
;    MOV AH, 01H
; READ_UNTIL_SPACE:
;     INT 21H
;     CMP AL, 20H
;     JNE READ_UNTIL_SPACE
;


; ================================================================
; INPUT 5: Read string until Enter (store in buffer)
; Buffer in .DATA, ends with '$' so you can print it later
; ================================================================
;
; .DATA
;    BUFFER DB 80 DUP(0)
;
; READ_STRING PROC
;     PUSH SI
;     MOV SI, OFFSET BUFFER
;
; RS_LOOP:
;     MOV AH, 01H
;     INT 21H
;     CMP AL, 0DH              ; Enter pressed?
;     JE  RS_DONE
;     MOV [SI], AL
;     INC SI
;     JMP RS_LOOP
;
; RS_DONE:
;     MOV BYTE PTR [SI], '$'   ; terminate for PRINT_STRING
;     POP SI
;     RET
; READ_STRING ENDP
;
; Usage:
;    CALL READ_STRING
;    MOV DX, OFFSET BUFFER
;    CALL PRINT_STRING
;


; ================================================================
; INPUT 6: Read multi-digit number until Enter/Space
; Result in AX. Uses loop + branching to build number.
; Example: user types 253 -> AX = 253
; ================================================================
;
; READ_NUMBER PROC
;     PUSH BX
;     XOR AX, AX               ; AX = 0
;
; RN_LOOP:
;     MOV AH, 01H
;     INT 21H
;
;     CMP AL, 0DH              ; Enter -> done
;     JE  RN_DONE
;     CMP AL, ' '
;     JE  RN_DONE
;
;     CMP AL, '0'              ; must be digit
;     JB  RN_LOOP
;     CMP AL, '9'
;     JA  RN_LOOP
;
;     SUB AL, '0'              ; digit value
;     MOV BL, AL
;     MOV BH, 0                ; BX = new digit
;
;     PUSH BX                  ; save digit
;     MOV BX, 10
;     MUL BX                   ; AX = AX * 10
;     POP BX                   ; restore digit
;     ADD AX, BX               ; AX = AX * 10 + digit
;
;     JMP RN_LOOP
;
; RN_DONE:
;     POP BX
;     RET
; READ_NUMBER ENDP
;
; Usage:  CALL READ_NUMBER
;         ; AX = number entered
;         CALL PRINT_NUMBER
;


; ================================================================
; INPUT 7: Count characters until Enter (branching loop)
; Result in DX. Enter is NOT counted.
; ================================================================
;
;    MOV DX, 0
;    MOV AH, 01H
;    INT 21H
;
; COUNT_UNTIL_CR:
;     CMP AL, 0DH
;     JE  COUNT_DONE
;     INC DX
;     INT 21H
;     JMP COUNT_UNTIL_CR
;
; COUNT_DONE:
;     ; DX = character count
;     MOV AX, DX
;     CALL PRINT_NUMBER
;


; ================================================================
; INPUT 8: Read N characters using LOOP (fixed count)
; Example: read exactly 5 digits
; ================================================================
;
;    MOV CX, 5
;    MOV SI, OFFSET BUFFER
;
; READ_N_LOOP:
;     CALL READ_DIGIT          ; AL = digit
;     ADD AL, '0'              ; store as ASCII (optional)
;     MOV [SI], AL
;     INC SI
;     LOOP READ_N_LOOP
;


; ================================================================
; INPUT 9: Yes/No branching (read y or n)
; Result: AL = 1 for 'y'/'Y', AL = 0 for 'n'/'N'
; ================================================================
;
; READ_YES_NO PROC
; RYN_LOOP:
;     MOV AH, 01H
;     INT 21H
;     CMP AL, 'y'
;     JE  RYN_YES
;     CMP AL, 'Y'
;     JE  RYN_YES
;     CMP AL, 'n'
;     JE  RYN_NO
;     CMP AL, 'N'
;     JE  RYN_NO
;     JMP RYN_LOOP             ; invalid -> ask again
;
; RYN_YES:
;     MOV AL, 1
;     RET
;
; RYN_NO:
;     MOV AL, 0
;     RET
; READ_YES_NO ENDP
;


; ================================================================
; FULL EXAMPLE SKELETON (copy into new .asm file)
; ================================================================
;
; .MODEL SMALL
; .STACK 100H
;
; .DATA
;    MSG1 DB 'Enter a digit: $'
;    MSG2 DB 'You entered: $'
;    BUFFER DB 80 DUP(0)
;
; .CODE
; MAIN PROC
;    MOV AX, @DATA
;    MOV DS, AX
;
;    ; prompt
;    MOV DX, OFFSET MSG1
;    CALL PRINT_STRING
;
;    ; input
;    CALL READ_DIGIT          ; AL = digit
;
;    ; output
;    MOV DX, OFFSET MSG2
;    CALL PRINT_STRING
;    CALL PRINT_DIGIT
;    CALL PRINT_NEWLINE
;
;    MOV AH, 4CH
;    INT 21H
; MAIN ENDP
;
; ; paste PRINT_CHAR, PRINT_STRING, PRINT_NEWLINE,
; ;       PRINT_DIGIT, READ_CHAR, READ_DIGIT here
;
; END MAIN
;
