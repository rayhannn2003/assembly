; ================================================================
; if_ELSE.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste IF / ELSE patterns into your program.
; Course focus: branching + loops
; ================================================================
;
; Assembly has NO "if" keyword. Pattern is always:
;
;   CMP  value1, value2
;   JE/JNE/JG/...  IF_BLOCK
;   ; ELSE block (runs when condition false)
;   JMP END_IF
; IF_BLOCK:
;   ; IF block
; END_IF:
;
; Think in C:
;   if (A == B) { ... } else { ... }
; ================================================================


; ================================================================
; MODULE 1: Basic IF-ELSE  (equal / not equal)
;
; C:  if (AL == 5) { print 'Y' } else { print 'N' }
; ================================================================
;
;    CMP AL, 5
;    JE  IF_EQUAL
;
;    ; ---- ELSE ----
;    MOV DL, 'N'
;    MOV AH, 02H
;    INT 21H
;    JMP END_IF1
;
; IF_EQUAL:
;    ; ---- IF ----
;    MOV DL, 'Y'
;    MOV AH, 02H
;    INT 21H
;
; END_IF1:
;


; ================================================================
; MODULE 2: IF only (no ELSE) - skip block when false
;
; C:  if (AL == 0DH) { do something }
; ================================================================
;
;    CMP AL, 0DH              ; Enter key?
;    JNE SKIP_IF2             ; if NOT equal, skip IF body
;
;    ; ---- IF body (runs only when AL == CR) ----
;    MOV DL, 'E'
;    MOV AH, 02H
;    INT 21H
;
; SKIP_IF2:
;    ; continues here whether IF ran or not
;


; ================================================================
; MODULE 3: IF-ELSE unsigned compare (>, <, >=, <=)
; Use for digits, counts, positive numbers
;
; C:  if (AL > 5) { ... } else { ... }
; ================================================================
;
;    CMP AL, 5
;    JA  IF_GREATER           ; unsigned AL > 5
;
;    ; ---- ELSE (AL <= 5) ----
;    MOV DL, 'S'              ; Small
;    MOV AH, 02H
;    INT 21H
;    JMP END_IF3
;
; IF_GREATER:
;    ; ---- IF (AL > 5) ----
;    MOV DL, 'B'              ; Big
;    MOV AH, 02H
;    INT 21H
;
; END_IF3:
;
; Other unsigned jumps:
;    CMP AL, 5
;    JB  LESS_THAN            ; AL < 5
;    JAE GREATER_EQUAL        ; AL >= 5
;    JBE LESS_EQUAL           ; AL <= 5
;


; ================================================================
; MODULE 4: IF-ELSE signed compare (negative numbers allowed)
;
; C:  if (AX > 0) { ... } else { ... }
; ================================================================
;
;    CMP AX, 0
;    JG  IF_POSITIVE          ; signed AX > 0
;
;    ; ---- ELSE ----
;    MOV DL, '-'
;    MOV AH, 02H
;    INT 21H
;    JMP END_IF4
;
; IF_POSITIVE:
;    MOV DL, '+'
;    MOV AH, 02H
;    INT 21H
;
; END_IF4:
;
; Signed jumps:  JG  JL  JGE  JLE
;


; ================================================================
; MODULE 5: IF - ELSE IF - ELSE  (multi-way ladder)
;
; C:  if (AL == '1') ...
;     else if (AL == '2') ...
;     else ...
; ================================================================
;
;    CMP AL, '1'
;    JE  OPTION_1
;    CMP AL, '2'
;    JE  OPTION_2
;    CMP AL, '3'
;    JE  OPTION_3
;    JMP OPTION_INVALID       ; else
;
; OPTION_1:
;    ; code for 1
;    JMP LADDER_DONE
;
; OPTION_2:
;    ; code for 2
;    JMP LADDER_DONE
;
; OPTION_3:
;    ; code for 3
;    JMP LADDER_DONE
;
; OPTION_INVALID:
;    ; else block
;
; LADDER_DONE:
;


; ================================================================
; MODULE 6: IF range check  (value between min and max)
;
; C:  if (AL >= '0' && AL <= '9')  -> valid digit
; ================================================================
;
;    CMP AL, '0'
;    JB  NOT_IN_RANGE         ; below min -> else
;    CMP AL, '9'
;    JA  NOT_IN_RANGE         ; above max -> else
;
;    ; ---- IF (in range) ----
;    MOV DL, 'V'              ; Valid
;    MOV AH, 02H
;    INT 21H
;    JMP RANGE_DONE
;
; NOT_IN_RANGE:
;    ; ---- ELSE ----
;    MOV DL, 'X'              ; Invalid
;    MOV AH, 02H
;    INT 21H
;
; RANGE_DONE:
;


; ================================================================
; MODULE 7: IF even / odd  (no DIV needed)
;
; C:  if (AL % 2 == 0) even else odd
; ================================================================
;
;    TEST AL, 1               ; check last bit (faster than DIV)
;    JZ  IF_EVEN
;
;    ; ---- ELSE odd ----
;    MOV DL, 'O'
;    MOV AH, 02H
;    INT 21H
;    JMP END_IF7
;
; IF_EVEN:
;    MOV DL, 'E'
;    MOV AH, 02H
;    INT 21H
;
; END_IF7:
;
; Or using AND:
;    MOV BL, AL
;    AND BL, 1
;    CMP BL, 0
;    JE  IF_EVEN
;


; ================================================================
; MODULE 8: IF vowel / ELSE consonant
;
; C:  if (c=='a'||c=='e'||...) vowel else consonant
; ================================================================
;
;    CMP AL, 'a'
;    JE  IS_VOWEL
;    CMP AL, 'e'
;    JE  IS_VOWEL
;    CMP AL, 'i'
;    JE  IS_VOWEL
;    CMP AL, 'o'
;    JE  IS_VOWEL
;    CMP AL, 'u'
;    JE  IS_VOWEL
;    JMP IS_CONSONANT         ; else
;
; IS_VOWEL:
;    INC VOWEL_CNT
;    JMP VC_DONE
;
; IS_CONSONANT:
;    INC CONSONANT_CNT
;
; VC_DONE:
;


; ================================================================
; MODULE 9: IF leap year  (compound conditions)
;
; C logic:
;   if (year%400==0) leap
;   else if (year%100==0) not leap
;   else if (year%4==0) leap
;   else not leap
; ================================================================
;
;    MOV CX, AX               ; CX = year
;
;    MOV AX, CX
;    XOR DX, DX
;    MOV BX, 400
;    DIV BX
;    CMP DX, 0
;    JE  LEAP_YEAR
;
;    MOV AX, CX
;    XOR DX, DX
;    MOV BX, 100
;    DIV BX
;    CMP DX, 0
;    JE  NOT_LEAP_YEAR
;
;    MOV AX, CX
;    XOR DX, DX
;    MOV BX, 4
;    DIV BX
;    CMP DX, 0
;    JE  LEAP_YEAR
;
;    JMP NOT_LEAP_YEAR
;
; LEAP_YEAR:
;    ; IF body
;    JMP LEAP_DONE
;
; NOT_LEAP_YEAR:
;    ; ELSE body
;
; LEAP_DONE:
;


; ================================================================
; MODULE 10: IF with user input + print message
;
; Read digit, if > 5 print "BIG" else print "SMALL"
; ================================================================
;
; .DATA
;    MSG_BIG   DB 'BIG$'
;    MSG_SMALL DB 'SMALL$'
;
;    MOV AH, 01H
;    INT 21H
;    SUB AL, '0'
;
;    CMP AL, 5
;    JA  PRINT_BIG
;
;    ; else
;    MOV DX, OFFSET MSG_SMALL
;    MOV AH, 09H
;    INT 21H
;    JMP SIZE_DONE
;
; PRINT_BIG:
;    MOV DX, OFFSET MSG_BIG
;    MOV AH, 09H
;    INT 21H
;
; SIZE_DONE:
;


; ================================================================
; MODULE 11: Nested IF-ELSE
;
; C:  if (AL > 0)
;         if (AL < 10) single digit
;         else          multi digit
;     else
;         negative
; ================================================================
;
;    CMP AL, 0
;    JLE OUTER_ELSE           ; AL <= 0
;
;    ; outer IF: AL > 0
;    CMP AL, 10
;    JB  INNER_IF             ; AL < 10
;
;    ; inner ELSE: AL >= 10
;    MOV DL, 'M'
;    JMP NESTED_PRINT
;
; INNER_IF:
;    MOV DL, 'S'
;    JMP NESTED_PRINT
;
; OUTER_ELSE:
;    MOV DL, 'N'
;
; NESTED_PRINT:
;    MOV AH, 02H
;    INT 21H
;


; ================================================================
; MODULE 12: IF-ELSE using flags after arithmetic
;
; C:  if (AX - BX == 0) equal else not equal
; ================================================================
;
;    CMP AX, BX
;    JE  VALUES_EQUAL
;
;    ; else
;    MOV DL, 'D'              ; Different
;    MOV AH, 02H
;    INT 21H
;    JMP CMP_DONE
;
; VALUES_EQUAL:
;    MOV DL, 'S'              ; Same
;    MOV AH, 02H
;    INT 21H
;
; CMP_DONE:
;


; ================================================================
; CHEAT SHEET: C to Assembly IF-ELSE
; ================================================================
;
;  C code                    Assembly pattern
;  ------------------------  ---------------------------------
;  if (a == b)               CMP a,b  /  JE if
;  if (a != b)               CMP a,b  /  JNE if
;  if (a > b)  unsigned      CMP a,b  /  JA if
;  if (a < b)  unsigned      CMP a,b  /  JB if
;  if (a >= b) unsigned      CMP a,b  /  JAE if
;  if (a <= b) unsigned      CMP a,b  /  JBE if
;  if (a > b)  signed        CMP a,b  /  JG if
;  if (a < b)  signed        CMP a,b  /  JL if
;  if (a >= b) signed        CMP a,b  /  JGE if
;  if (a <= b) signed        CMP a,b  /  JLE if
;
;  REMEMBER: else block comes FIRST in assembly,
;            then JMP END, then if block, then END label.
;            (or use JNE to skip if-body — MODULE 2)
;


; ================================================================
; FULL RUNNABLE EXAMPLE (copy to new .asm file)
; ================================================================
;
; .MODEL SMALL
; .STACK 100H
;
; .DATA
;    MSG_YES DB 'Even$'
;    MSG_NO  DB 'Odd$'
;
; .CODE
; MAIN PROC
;     MOV AX, @DATA
;     MOV DS, AX
;
;     MOV AH, 01H
;     INT 21H                  ; read digit char
;     SUB AL, '0'
;
;     TEST AL, 1
;     JZ  IF_EVEN
;
;     ; else odd
;     MOV DX, OFFSET MSG_NO
;     MOV AH, 09H
;     INT 21H
;     JMP DONE
;
; IF_EVEN:
;     MOV DX, OFFSET MSG_YES
;     MOV AH, 09H
;     INT 21H
;
; DONE:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;
