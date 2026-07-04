; ================================================================
; loop.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste LOOP patterns into your program.
; Course focus: branching + loops
; ================================================================
;
; LOOP instruction:
;   MOV CX, count
; LABEL:
;     ; body
;     LOOP LABEL           ; CX = CX - 1; jump if CX != 0
;
; WARNING: if CX = 0 before LOOP, it runs 65536 times!
;   Always set CX > 0, or check:
;     CMP CX, 0
;     JE  SKIP_LOOP
;
; RULE for nested loops:
;   LOOP uses CX only. Inner LOOP destroys CX.
;   Fix: outer use DEC/JNZ, or PUSH/POP CX around inner LOOP.
; ================================================================


; ================================================================
; MODULE 1: Basic LOOP - print N times (e.g. 80 stars)
; ================================================================
;
;    MOV CX, 80
;
; STAR_LOOP:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP STAR_LOOP
;


; ================================================================
; MODULE 2: WHILE loop (condition at top)
;
; C:  while (AL != CR) { ... read next ... }
; ================================================================
;
;    MOV AH, 01H
;    INT 21H                  ; read first char
;
; WHILE_TOP:
;     CMP AL, 0DH              ; Enter?
;     JE  WHILE_END
;
;     ; ---- loop body ----
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;
;     MOV AH, 01H
;     INT 21H                  ; read next
;     JMP WHILE_TOP
;
; WHILE_END:
;


; ================================================================
; MODULE 3: DO-WHILE loop (body runs at least once)
;
; C:  do { ... } while (AL != SPACE);
; ================================================================
;
;    MOV AH, 01H
;
; DO_WHILE:
;     INT 21H
;     ; body here
;     CMP AL, 20H              ; Space?
;     JNE DO_WHILE
;


; ================================================================
; MODULE 4: FOR loop with LOOP (CX = 1 to N)
;
; C:  for (i = 0; i < N; i++) ...
; ================================================================
;
;    MOV CX, 10               ; repeat 10 times
;
; FOR_LOOP:
;     ; body
;     LOOP FOR_LOOP
;


; ================================================================
; MODULE 5: FOR loop with BX (DEC / JNZ) - safer for nested loops
;
; C:  for (i = 1; i <= N; i++)
; ================================================================
;
;    MOV BX, 1                ; i = 1
;    MOV DH, 5                ; N = 5 (save N in safe register)
;
; FOR_BX:
;     CMP BX, DH               ; i <= N ?
;     JG  FOR_DONE
;
;     ; body using BX as counter
;
;     INC BX
;     JMP FOR_BX
;
; FOR_DONE:
;


; ================================================================
; MODULE 6: Count characters until Enter
;
; C:  count = 0; while (c != CR) { count++; read next; }
; ================================================================
;
;    MOV DX, 0                ; count
;    MOV AH, 01H
;    INT 21H
;
; COUNT_LOOP:
;     CMP AL, 0DH
;     JE  COUNT_DONE
;     INC DX
;     INT 21H
;     JMP COUNT_LOOP
;
; COUNT_DONE:
;     ; DX = count
;


; ================================================================
; MODULE 7: Read until condition (space / enter / digit)
; ================================================================
;
;    MOV AH, 01H
;
; READ_UNTIL:
;     INT 21H
;     CMP AL, 20H              ; until Space
;     JNE READ_UNTIL
;
; Or skip invalid keys:
; RD_VALID:
;     INT 21H
;     CMP AL, '0'
;     JB  RD_VALID
;     CMP AL, '9'
;     JA  RD_VALID
;     ; got valid digit
;


; ================================================================
; MODULE 8: NESTED LOOP - method A (outer DEC/JNZ, inner LOOP)
; Best and easiest for exams.
;
; Print 4 rows, 5 stars each:
; *****
; *****
; *****
; *****
; ================================================================
;
;    MOV BX, 4                ; 4 rows (outer)
;
; OUTER_ROW:
;     MOV CX, 5              ; 5 stars per row (inner)
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


; ================================================================
; MODULE 9: NESTED LOOP - method B (PUSH/POP CX, both use LOOP)
; Use when outer and inner both need LOOP instruction.
; ================================================================
;
;    MOV BX, 3                ; save n in BX (NOT AX - INT 21H kills AX)
;    MOV CX, BX               ; outer count
;
; OUTER_LOOP:
;     PUSH CX                  ; save outer CX
;     MOV CX, BX               ; inner count = n
;
; INNER_LOOP:
;     MOV DL, '#'
;     MOV AH, 02H
;     INT 21H
;     LOOP INNER_LOOP
;
;     ; newline
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     POP CX
;     LOOP OUTER_LOOP
;
; n=3 prints 3 rows of 3 '#' each.
;


; ================================================================
; MODULE 10: NESTED LOOP - square pattern (n x n from user input)
;
; Input n, print n rows of n '#' characters
; ================================================================
;
;    ; read n
;    MOV AH, 01H
;    INT 21H
;    SUB AL, '0'
;    MOV AH, 0
;    MOV BX, AX               ; BX = n (keep safe!)
;
;    ; newline after input
;    MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;    MOV CX, BX               ; outer = n
;
; SQ_OUTER:
;     PUSH CX
;     MOV CX, BX               ; inner = n (use BX not AX!)
;
; SQ_INNER:
;     MOV DL, '#'
;     MOV AH, 02H
;     INT 21H
;     LOOP SQ_INNER
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     POP CX
;     LOOP SQ_OUTER
;


; ================================================================
; MODULE 11: NESTED LOOP - triangle (row i prints i stars)
;
; *
; **
; ***
; ****
; ================================================================
;
;    MOV DH, 4                ; n = 4 rows
;    MOV BX, 1                ; current row
;
; TRI_ROW:
;     MOV CX, BX               ; print BX stars
;
; TRI_COL:
;     MOV DL, '*'
;     MOV AH, 02H
;     INT 21H
;     LOOP TRI_COL
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     CMP BL, DH
;     JLE TRI_ROW              ; while row <= n
;


; ================================================================
; MODULE 12: NESTED LOOP - print number triangle
;
; 1
; 1 2
; 1 2 3
; 1 2 3 4
; ================================================================
;
;    MOV DH, 4                ; n rows
;    MOV BX, 1                ; row
;
; NUM_ROW:
;     MOV CX, 1                ; col
;
; NUM_COL:
;     MOV AL, CL
;     ADD AL, '0'
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;
;     MOV DL, ' '
;     INT 21H
;
;     INC CX
;     CMP CX, BX
;     JLE NUM_COL
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     INC BX
;     CMP BL, DH
;     JLE NUM_ROW
;


; ================================================================
; MODULE 13: LOOP with index in BX (1 to N, print each)
; ================================================================
;
;    MOV BX, 1
;    MOV DH, 5
;
; INDEX_LOOP:
;     CMP BX, DH
;     JG  INDEX_DONE
;
;     ; use BX as current number
;     MOV AX, BX
;     ; print AX ...
;
;     INC BX
;     JMP INDEX_LOOP
;
; INDEX_DONE:
;


; ================================================================
; NESTED LOOP - which method to pick?
; ================================================================
;
;  Situation                          Use
;  --------------------------------   ---------------------------
;  Outer rows, inner cols             MODULE 8 (DEC/JNZ outer)
;  Both must use LOOP                 MODULE 9 (PUSH/POP CX)
;  n from user, n x n grid            MODULE 10 (BX holds n)
;  Growing inner count (triangle)     MODULE 11 (CX = BX)
;  Inner col depends on row           MODULE 12 (CMP CX, BX)
;


; ================================================================
; CHEAT SHEET: C loop to Assembly
; ================================================================
;
;  C code                    Assembly
;  ------------------------  ----------------------------------
;  while (cond)              TOP: CMP ... / JE END / body / JMP TOP
;  do { } while (cond)       TOP: body / CMP ... / JNE TOP
;  for (i=0;i<N;i++)         MOV CX,N / LOOP label
;  for (i=1;i<=N;i++)        MOV BX,1 / CMP/JG done / INC BX / JMP
;  repeat N times            MOV CX,N / LOOP label
;


; ================================================================
; FULL RUNNABLE EXAMPLE: nested 3x3 hash grid
; ================================================================
;
; .MODEL SMALL
; .STACK 100H
; .CODE
; MAIN PROC
;     MOV AX, @DATA
;     MOV DS, AX
;
;     MOV BX, 3
;     MOV CX, BX
;
; OUTER:
;     PUSH CX
;     MOV CX, BX
;
; INNER:
;     MOV DL, '#'
;     MOV AH, 02H
;     INT 21H
;     LOOP INNER
;
;     MOV DL, 0DH
;     MOV AH, 02H
;     INT 21H
;     MOV DL, 0AH
;     INT 21H
;
;     POP CX
;     LOOP OUTER
;
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;
