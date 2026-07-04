; ================================================================
; case.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste CASE (multi-way branch) patterns into your program.
; Course focus: branching + loops
; ================================================================
;
; CASE = multi-way branch (like switch in C)
;
; CASE expression
;   value_1: statements_1
;   value_2: statements_2
;   ...
; END_CASE
;
; Assembly pattern:
;   CMP reg, value1  /  JE case1
;   CMP reg, value2  /  JE case2
;   JMP default_or_end
; case1:
;   ...
;   JMP END_CASE
; case2:
;   ...
; END_CASE:
;
; RULE: each case body ends with JMP END_CASE (except last case)
; ================================================================


; ================================================================
; MODULE 1: CASE on sign of AX (Example 6-4)
;
; CASE AX
;   < 0:  BX = -1
;   = 0:  BX = 0
;   > 0:  BX = 1
; END_CASE
; ================================================================
;
;    CMP AX, 0
;    JL  CASE_NEGATIVE        ; AX < 0
;    JE  CASE_ZERO            ; AX = 0
;    JG  CASE_POSITIVE        ; AX > 0
;    JMP END_CASE1
;
; CASE_NEGATIVE:
;    MOV BX, -1
;    JMP END_CASE1
;
; CASE_ZERO:
;    MOV BX, 0
;    JMP END_CASE1
;
; CASE_POSITIVE:
;    MOV BX, 1
;
; END_CASE1:
;


; ================================================================
; MODULE 2: CASE on exact values - odd/even groups (Example 6-4)
;
; CASE AL
;   1, 3:  display 'o'
;   2, 4:  display 'e'
; END_CASE
; ================================================================
;
;    CMP AL, 1
;    JE  CASE_ODD
;    CMP AL, 3
;    JE  CASE_ODD
;    CMP AL, 2
;    JE  CASE_EVEN
;    CMP AL, 4
;    JE  CASE_EVEN
;    JMP END_CASE2            ; no match -> skip
;
; CASE_ODD:
;    MOV DL, 'o'
;    JMP CASE_DISPLAY
;
; CASE_EVEN:
;    MOV DL, 'e'
;
; CASE_DISPLAY:
;    MOV AH, 02H
;    INT 21H
;
; END_CASE2:
;


; ================================================================
; MODULE 3: CASE on menu choice ('1', '2', '3')
;
; CASE AL
;   '1': option A
;   '2': option B
;   '3': option C
;   else: invalid
; END_CASE
; ================================================================
;
;    CMP AL, '1'
;    JE  CASE_OPT1
;    CMP AL, '2'
;    JE  CASE_OPT2
;    CMP AL, '3'
;    JE  CASE_OPT3
;    JMP CASE_INVALID
;
; CASE_OPT1:
;    ; statements for 1
;    JMP END_CASE3
;
; CASE_OPT2:
;    ; statements for 2
;    JMP END_CASE3
;
; CASE_OPT3:
;    ; statements for 3
;    JMP END_CASE3
;
; CASE_INVALID:
;    ; default / else
;
; END_CASE3:
;


; ================================================================
; MODULE 4: CASE on digit 0-9 (ten cases)
;
; CASE AL  (AL = '0'..'9')
; ================================================================
;
;    CMP AL, '0'
;    JE  DIGIT_0
;    CMP AL, '1'
;    JE  DIGIT_1
;    CMP AL, '2'
;    JE  DIGIT_2
;    ; ... continue for '3' to '9'
;    JMP CASE_DEFAULT
;
; DIGIT_0:
;    ...
;    JMP END_CASE4
; DIGIT_1:
;    ...
;    JMP END_CASE4
; ; etc.
;
; CASE_DEFAULT:
;    ...
; END_CASE4:
;


; ================================================================
; MODULE 5: CASE with range (unsigned ranges as separate cases)
;
; CASE AL
;   1..3:   small
;   4..6:   medium
;   7..9:   large
; END_CASE
; ================================================================
;
;    CMP AL, 1
;    JB  END_CASE5
;    CMP AL, 3
;    JBE CASE_SMALL
;
;    CMP AL, 4
;    JB  END_CASE5
;    CMP AL, 6
;    JBE CASE_MEDIUM
;
;    CMP AL, 7
;    JB  END_CASE5
;    CMP AL, 9
;    JBE CASE_LARGE
;    JMP END_CASE5
;
; CASE_SMALL:
;    ...
;    JMP END_CASE5
;
; CASE_MEDIUM:
;    ...
;    JMP END_CASE5
;
; CASE_LARGE:
;    ...
;
; END_CASE5:
;


; ================================================================
; MODULE 6: CASE on character type (letter / digit / other)
; ================================================================
;
;    CMP AL, '0'
;    JB  TRY_LETTER
;    CMP AL, '9'
;    JBE CASE_DIGIT
;
; TRY_LETTER:
;    CMP AL, 'A'
;    JB  CASE_OTHER
;    CMP AL, 'Z'
;    JBE CASE_LETTER
;    CMP AL, 'a'
;    JB  CASE_OTHER
;    CMP AL, 'z'
;    JBE CASE_LETTER
;    JMP CASE_OTHER
;
; CASE_DIGIT:
;    ...
;    JMP END_CASE6
;
; CASE_LETTER:
;    ...
;    JMP END_CASE6
;
; CASE_OTHER:
;    ...
;
; END_CASE6:
;


; ================================================================
; MODULE 7: CASE on vowel (multiple values -> one case body)
; Same idea as MODULE 2 (OR within CASE)
;
; CASE AL:  a,e,i,o,u -> vowel
;           else      -> consonant
; ================================================================
;
;    CMP AL, 'a'
;    JE  CASE_VOWEL
;    CMP AL, 'e'
;    JE  CASE_VOWEL
;    CMP AL, 'i'
;    JE  CASE_VOWEL
;    CMP AL, 'o'
;    JE  CASE_VOWEL
;    CMP AL, 'u'
;    JE  CASE_VOWEL
;    JMP CASE_CONSONANT
;
; CASE_VOWEL:
;    INC VOWEL_CNT
;    JMP END_CASE7
;
; CASE_CONSONANT:
;    INC CONSONANT_CNT
;
; END_CASE7:
;


; ================================================================
; MODULE 8: CASE with shared code (jump to common block)
; From textbook: ODD and EVEN both go to DISPLAY
;
; Pattern:
;   case A: load value A / JMP SHARED
;   case B: load value B / JMP SHARED
;   SHARED: common code
; ================================================================
;
;    CMP AL, 'Y'
;    JE  CASE_YES
;    CMP AL, 'y'
;    JE  CASE_YES
;    CMP AL, 'N'
;    JE  CASE_NO
;    CMP AL, 'n'
;    JE  CASE_NO
;    JMP END_CASE8
;
; CASE_YES:
;    MOV DL, 'Y'
;    JMP CASE_PRINT
;
; CASE_NO:
;    MOV DL, 'N'
;
; CASE_PRINT:
;    MOV AH, 02H
;    INT 21H
;
; END_CASE8:
;


; ================================================================
; MODULE 9: CASE inside a loop (scan string char by char)
;
; for each character: CASE char -> count vowel or consonant
; ================================================================
;
; SCAN_LOOP:
;     MOV AL, [SI]
;     CMP AL, '$'
;     JE  SCAN_DONE
;
;     ; CASE on AL (vowel or consonant) - use MODULE 7
;
;     INC SI
;     JMP SCAN_LOOP
;
; SCAN_DONE:
;


; ================================================================
; CHEAT SHEET: CASE patterns
; ================================================================
;
;  Case type              Assembly approach
;  ---------------------  ----------------------------------------
;  Exact value match      CMP AL, val / JE case_label
;  Several -> one body    CMP/JE each value / JMP shared_label
;  Sign (<, =, >)         CMP AX,0 / JL / JE / JG
;  Range (1..3)           CMP min / JB skip / CMP max / JBE case
;  Default (else)         final JMP DEFAULT before case labels
;  Exit all cases         JMP END_CASE after each case body
;
;  C switch               Assembly CASE
;  ----------------       -----------------
;  switch(n) {            CMP AL, 1 / JE c1
;    case 1: ...          CMP AL, 2 / JE c2
;    case 2: ...          JMP def
;    default: ...         c1: ... / JMP end
;  }                      c2: ... / JMP end
;                         def: ...
;                         end:
;


; ================================================================
; FULL RUNNABLE EXAMPLE 1: Sign of AX -> BX (Example 6-4)
; ================================================================
;
; .MODEL SMALL
; .STACK 100H
; .CODE
; MAIN PROC
;     MOV AX, @DATA
;     MOV DS, AX
;
;     MOV AX, 5                ; try 5, 0, -3
;
;     CMP AX, 0
;     JL  NEGATIVE
;     JE  ZERO
;     JG  POSITIVE
;     JMP END_CASE
;
; NEGATIVE:
;     MOV BX, -1
;     JMP END_CASE
;
; ZERO:
;     MOV BX, 0
;     JMP END_CASE
;
; POSITIVE:
;     MOV BX, 1
;
; END_CASE:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;


; ================================================================
; FULL RUNNABLE EXAMPLE 2: 1,3='o'  2,4='e' (Example 6-4)
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
;     INT 21H                  ; read digit char into AL
;     SUB AL, '0'              ; optional: numeric 1-4
;
;     CMP AL, 1
;     JE  ODD
;     CMP AL, 3
;     JE  ODD
;     CMP AL, 2
;     JE  EVEN
;     CMP AL, 4
;     JE  EVEN
;     JMP END_CASE
;
; ODD:
;     MOV DL, 'o'
;     JMP DISPLAY
;
; EVEN:
;     MOV DL, 'e'
;
; DISPLAY:
;     MOV AH, 02H
;     INT 21H
;
; END_CASE:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;
