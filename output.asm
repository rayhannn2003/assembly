; ================================================================
; input.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste INPUT / OUTPUT modules into your program.
; Course focus: branching + loops (no arrays needed in logic)
; ================================================================
;
; DOS quick reference:
;   AH=01H  read char (echo)     -> AL = character
;   AH=02H  print char           -> DL = character
;   AH=09H  print string         -> DX = offset, ends with '$'
;
; Common ASCII:
;   CR=0DH (Enter)   LF=0AH (newline)   SPACE=20H
; ================================================================


; ================================================================
; CONSTANT: ASCII values (use in CMP)
; ================================================================
;
; CR    EQU 0DH
; LF    EQU 0AH
; SPACE EQU 20H
;


; ================================================================
; OUTPUT 1: Print one character
; Set DL = character before calling INT 21H
; ================================================================
;
;    MOV DL, '*'
;    MOV AH, 02H
;    INT 21H
;


; ================================================================
; OUTPUT 2: Print character from AL
; ================================================================
;
; PRINT_CHAR PROC
;     PUSH AX
;     PUSH DX
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;     POP DX
;     POP AX
;     RET
; PRINT_CHAR ENDP
;
; Usage:  MOV AL, 'A'
;         CALL PRINT_CHAR
;


; ================================================================
; OUTPUT 3: Print string (must end with '$')
; ================================================================
;
;    MOV DX, OFFSET MSG
;    MOV AH, 09H
;    INT 21H
;
; Or as procedure:
;
; PRINT_STRING PROC
;     MOV AH, 09H
;     INT 21H
;     RET
; PRINT_STRING ENDP
;
; .DATA
;    MSG DB 'Hello World$'
;


; ================================================================
; OUTPUT 4: Print newline (go to next line)
; ================================================================
;
;    MOV DL, 0DH
;    MOV AH, 02H
;    INT 21H
;    MOV DL, 0AH
;    MOV AH, 02H
;    INT 21H
;
; Or as procedure:
;
; PRINT_NEWLINE PROC
;     PUSH AX
;     MOV AL, 0DH
;     CALL PRINT_CHAR
;     MOV AL, 0AH
;     CALL PRINT_CHAR
;     POP AX
;     RET
; PRINT_NEWLINE ENDP
;


; ================================================================
; OUTPUT 5: Print single digit (0-9)
; Input: AL = digit value (NOT ASCII)
; ================================================================
;
; PRINT_DIGIT PROC
;     PUSH AX
;     PUSH DX
;     ADD AL, '0'              ; convert to ASCII
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;     POP DX
;     POP AX
;     RET
; PRINT_DIGIT ENDP
;
; Usage:  MOV AL, 7
;         CALL PRINT_DIGIT     ; prints '7'
;


; ================================================================
; OUTPUT 6: Print number (0-65535) using DIV loop
; Input: AX = number
; ================================================================
;
; PRINT_NUMBER PROC
;     PUSH AX
;     PUSH BX
;     PUSH CX
;     PUSH DX
;
;     MOV CX, 0                ; digit count on stack
;     MOV BX, 10
;
; PN_DIV_LOOP:
;     XOR DX, DX
;     DIV BX                 ; AX = quotient, DX = remainder
;     PUSH DX                ; save remainder (digit)
;     INC CX
;     OR  AX, AX
;     JNZ PN_DIV_LOOP
;
; PN_PRINT_LOOP:
;     POP DX
;     ADD DL, '0'
;     MOV AH, 02H
;     INT 21H
;     LOOP PN_PRINT_LOOP
;
;     POP DX
;     POP CX
;     POP BX
;     POP AX
;     RET
; PRINT_NUMBER ENDP
;
; Usage:  MOV AX, 253
;         CALL PRINT_NUMBER    ; prints 253
;
; Simpler version for numbers 0-99 only (no procedure):
;
;    MOV BL, 10
;    XOR DX, DX
;    DIV BL                   ; AL=tens, AH=ones
;    OR  AL, AL
;    JZ  PN_ONES
;    PUSH AX
;    ADD AL, '0'
;    MOV DL, AL
;    MOV AH, 02H
;    INT 21H
;    POP AX
; PN_ONES:
;    MOV AL, AH
;    ADD AL, '0'
;    MOV DL, AL
;    MOV AH, 02H
;    INT 21H
;

