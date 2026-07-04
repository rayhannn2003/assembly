; ================================================================
; jump.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste branching / jump modules into your program.
; Course focus: branching + loops
; ================================================================
;
; RULE: Conditional jumps decide using FLAGS (set by CMP, TEST, ADD, etc.)
;       Always CMP (or TEST) first, then jump.
;
;       CMP A, B   does  A - B  (result not stored, only flags change)
;
; Quick flag meanings:
;   ZF = 1  -> result was zero        (equal)
;   CF = 1  -> unsigned borrow        (below)
;   SF = 1  -> result negative        (sign)
;   OF = 1  -> signed overflow
; ================================================================


; ================================================================
; 1. UNCONDITIONAL JUMP (JMP)
; Always jumps. No condition. No flags needed.
; ================================================================
;
;    JMP LABEL                  ; go to LABEL (forward or backward)
;
; Example: infinite loop
; AGAIN:
;     ...
;     JMP AGAIN
;
; Example: skip a block
;     JMP SKIP
; DONT_RUN:
;     ...
; SKIP:
;


; ================================================================
; 2. CONDITIONAL JUMP - EQUAL / NOT EQUAL (all numbers)
; Use after:  CMP reg, value   or   CMP reg1, reg2
; ================================================================
;
;    CMP AL, 5
;    JE  EQUAL_LABEL          ; Jump if Equal        (ZF=1)
;    JNE NOT_EQUAL_LABEL      ; Jump if Not Equal    (ZF=0)
;
;    CMP AX, BX
;    JZ  ZERO_LABEL           ; Jump if Zero         (same as JE)
;    JNZ NONZERO_LABEL        ; Jump if Not Zero     (same as JNE)
;
; Example: check if Enter pressed
;    CMP AL, 0DH
;    JE  ENTER_PRESSED
;
; Example: read until space
; READ_LOOP:
;     INT 21H
;     CMP AL, 20H
;     JNE READ_LOOP
;


; ================================================================
; 3. UNSIGNED JUMP (JA/JB/JAE/JBE) - for positive counts, digits
; Treats numbers as UNSIGNED (0 to 255 for byte, 0 to 65535 for word)
; Use for: array sizes, digits, characters, counts
; ================================================================
;
;    CMP AL, BL
;    JA  ABOVE_LABEL          ; Jump if Above        (unsigned >)   CF=0 and ZF=0
;    JB  BELOW_LABEL          ; Jump if Below        (unsigned <)   CF=1
;    JAE ABOVE_EQUAL_LABEL    ; Jump if Above/Equal  (unsigned >=)  CF=0
;    JBE BELOW_EQUAL_LABEL    ; Jump if Below/Equal  (unsigned <=)  CF=1 or ZF=1
;
; Aliases (same instructions):
;    JA  = JNBE    (not below nor equal)
;    JAE = JNB / JNC   (not below / no carry)
;    JB  = JC / JNAE   (below / carry)
;    JBE = JNA         (not above)
;
; Example: AL in range '0'..'9' ?
;    CMP AL, '0'
;    JB  NOT_DIGIT            ; below '0'
;    CMP AL, '9'
;    JA  NOT_DIGIT            ; above '9'
;    ; valid digit
;
; Example: loop while CX > 0 (often use LOOP instead)
; CHECK_CX:
;     CMP CX, 0
;     JE  DONE
;     ...
;     DEC CX
;     JMP CHECK_CX
;


; ================================================================
; 4. SIGNED JUMP (JG/JL/JGE/JLE) - for negative numbers allowed
; Treats numbers as SIGNED (two's complement: -128..127 byte)
; Use for: temperature, difference, math with negatives
; ================================================================
;
;    CMP AX, BX
;    JG  GREATER_LABEL        ; Jump if Greater       (signed >)   ZF=0 and SF=OF
;    JL  LESS_LABEL           ; Jump if Less          (signed <)   SF!=OF
;    JGE GREATER_EQUAL_LABEL  ; Jump if Greater/Equal (signed >=)  SF=OF
;    JLE LESS_EQUAL_LABEL     ; Jump if Less/Equal    (signed <=)  ZF=1 or SF!=OF
;
; Aliases:
;    JG  = JNLE
;    JGE = JNL
;    JL  = JNGE
;    JLE = JNG
;
; Example: is AX positive ?
;    CMP AX, 0
;    JG  POSITIVE
;    JL  NEGATIVE
;    ; AX is zero
;
; Example: signed compare
;    CMP AL, -5               ; compare with -5 (use 0FBH for byte -5)
;    JLE NOT_GREATER
;


; ================================================================
; 5. UNSIGNED vs SIGNED - when to use which?
; ================================================================
;
;    CMP AL, 250
;
;    ; UNSIGNED view: 5 < 250  -> JB works (5 is below 250)
;    MOV AL, 5
;    CMP AL, 250
;    JB  UNSIGNED_LESS         ; JUMPS (correct for unsigned)
;
;    ; SIGNED view: 5 > -6     but 250 as signed byte = -6
;    ; same CMP: JL might differ from JB!
;
; Rule for exam:
;   digits, counts, ASCII, sizes  ->  JA / JB / JAE / JBE
;   negative numbers allowed      ->  JG / JL / JGE / JLE
;


; ================================================================
; 6. CARRY FLAG JUMPS (JC / JNC) - addition/subtraction borrow
; ================================================================
;
;    CMP AL, 10
;    JC  BELOW_10             ; Jump if Carry (unsigned <)
;
;    JNC NOT_BELOW            ; Jump if No Carry (unsigned >=)
;
; Example: after SUB
;    SUB AL, BL
;    JC  UNDERFLOW            ; AL was smaller than BL (unsigned)
;


; ================================================================
; 7. SIGN FLAG JUMPS (JS / JNS) - positive or negative result
; ================================================================
;
;    CMP AX, 0
;    JS  NEGATIVE             ; Jump if Sign (result negative)
;    JNS POSITIVE_OR_ZERO     ; Jump if No Sign
;


; ================================================================
; 8. LOOP instruction (count-controlled branch)
; Uses CX as counter. Combines DEC CX + conditional jump.
; ================================================================
;
;    MOV CX, 5
; PRINT_FIVE:
;     ...
;     LOOP PRINT_FIVE        ; CX--; jump if CX != 0
;
; WARNING: CX=0 then LOOP runs 65536 times!
;    Always set CX before LOOP:
;    MOV CX, N
;    CMP CX, 0
;    JE  SKIP_LOOP
;
; Nested loops: save outer CX with PUSH/POP or use DEC/JNZ for outer
;


; ================================================================
; 9. COMMON PATTERNS (copy-paste)
; ================================================================

; --- Pattern A: if-else ---
;
;    CMP AL, 5
;    JE  IF_PART
;    ; else part
;    JMP END_IF
; IF_PART:
;    ; if part
; END_IF:
;

; --- Pattern B: if only (no else) ---
;
;    CMP AL, 0DH
;    JNE SKIP
;    ; runs only if AL == CR
; SKIP:
;

; --- Pattern C: while loop ---
;
; WHILE_TOP:
;     CMP AL, 0DH
;     JE  WHILE_END
;     ; body
;     INT 21H                  ; read next
;     JMP WHILE_TOP
; WHILE_END:
;

; --- Pattern D: do-while loop (run at least once) ---
;
; DO_TOP:
;     ; body
;     INT 21H
;     CMP AL, 20H
;     JNE DO_TOP               ; repeat until space
;

; --- Pattern E: for-style loop with counter ---
;
;    MOV CX, 10
; FOR_LOOP:
;     ; body
;     LOOP FOR_LOOP
;

; --- Pattern F: for-style with BX (no LOOP) ---
;
;    MOV BX, 1
; FOR_BX:
;     CMP BX, 11               ; while BX <= 10
;     JG  FOR_DONE
;     ; body using BX
;     INC BX
;     JMP FOR_BX
; FOR_DONE:
;

; --- Pattern G: menu / multi-way branch ---
;
;    CMP AL, '1'
;     JE  OPTION1
;    CMP AL, '2'
;     JE  OPTION2
;    CMP AL, '3'
;     JE  OPTION3
;     JMP INVALID
; OPTION1:
;     ...
;     JMP MENU_DONE
; OPTION2:
;     ...
;     JMP MENU_DONE
; OPTION3:
;     ...
; MENU_DONE:
;


; ================================================================
; 10. CMP + JUMP CHEAT SHEET
; ================================================================
;
;  Goal              CMP              Jump
;  ----------------  ---------------  ------------------
;  A == B            CMP A, B         JE / JZ
;  A != B            CMP A, B         JNE / JNZ
;  A >  B unsigned   CMP A, B         JA
;  A >= B unsigned   CMP A, B         JAE
;  A <  B unsigned   CMP A, B         JB
;  A <= B unsigned   CMP A, B         JBE
;  A >  B signed     CMP A, B         JG
;  A >= B signed     CMP A, B         JGE
;  A <  B signed     CMP A, B         JL
;  A <= B signed     CMP A, B         JLE
;  A == 0            CMP A, 0         JE / JZ
;  A != 0            CMP A, 0         JNE / JNZ
;  A >= 0 signed     CMP A, 0         JGE
;  A <  0 signed     CMP A, 0         JL
;


; ================================================================
; 11. FULL MINI EXAMPLE (conditional + unconditional + loop)
; ================================================================
;
; .MODEL SMALL
; .STACK 100H
; .CODE
; MAIN PROC
;     MOV AX, @DATA
;     MOV DS, AX
;
;     MOV AH, 01H
;     INT 21H                  ; read char in AL
;
;     CMP AL, '0'
;     JB  NOT_DIGIT            ; unsigned below '0'
;     CMP AL, '9'
;     JA  NOT_DIGIT            ; unsigned above '9'
;
;     ; is digit - print it
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;     JMP EXIT_PROG
;
; NOT_DIGIT:
;     MOV DL, '?'
;     MOV AH, 02H
;     INT 21H
;
; EXIT_PROG:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;
