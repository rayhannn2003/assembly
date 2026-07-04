; ================================================================
; compound_branch.asm  -  REFERENCE ONLY (do not assemble this file)
; Copy-paste compound AND / OR branching into your program.
; Course focus: branching + loops
; ================================================================
;
; Compound conditions in IF:
;   condition_1 AND condition_2
;   condition_1 OR  condition_2
;
; Assembly has NO "AND" / "OR" keywords for logic.
; You build them with multiple CMP + conditional jumps.
;
; AND rule: fail fast -> if ANY condition fails, skip IF body
; OR  rule: succeed fast -> if ANY condition passes, run IF body
; ================================================================


; ================================================================
; MODULE 1: AND condition - uppercase letter (A to Z)
;
; C:  if (AL >= 'A' && AL <= 'Z') display AL
;
; From textbook Example 6-6
; ================================================================
;
;    MOV AH, 01H              ; read character
;    INT 21H                  ; char in AL
;
;    CMP AL, 'A'              ; char >= 'A' ?
;    JL  END_IF_AND1          ; no -> exit IF (signed/unsigned same for letters)
;
;    CMP AL, 'Z'              ; char <= 'Z' ?
;    JG  END_IF_AND1          ; no -> exit IF
;
;    ; both conditions true -> display character
;    MOV DL, AL
;    MOV AH, 02H
;    INT 21H
;
; END_IF_AND1:
;
; Alternative jumps (same logic):
;    CMP AL, 'A'
;    JNGE END_IF_AND1         ; jump if NOT >= 'A'
;    CMP AL, 'Z'
;    JNLE END_IF_AND1         ; jump if NOT <= 'Z'
;


; ================================================================
; MODULE 2: OR condition - 'y' or 'Y' (else terminate)
;
; C:  if (AL == 'y' || AL == 'Y') display AL
;     else terminate program
;
; From textbook Example 6-7
; ================================================================
;
;    MOV AH, 01H
;    INT 21H                  ; char in AL
;
;    CMP AL, 'Y'
;    JE  THEN_OR2             ; condition 1 true
;    CMP AL, 'y'
;    JE  THEN_OR2             ; condition 2 true
;    JMP ELSE_OR2             ; neither true -> ELSE
;
; THEN_OR2:
;    MOV DL, AL
;    MOV AH, 02H
;    INT 21H
;    JMP END_IF_OR2
;
; ELSE_OR2:
;    MOV AH, 4CH              ; terminate program
;    INT 21H
;
; END_IF_OR2:
;


; ================================================================
; MODULE 3: AND - general pattern (two conditions)
;
; C:  if (cond1 && cond2) { ... }
;
; Pattern: test cond1, fail -> END
;          test cond2, fail -> END
;          ... IF body ...
; END:
; ================================================================
;
;    ; cond1:  AL >= MIN
;    CMP AL, MIN
;    JL  END_AND
;
;    ; cond2:  AL <= MAX
;    CMP AL, MAX
;    JG  END_AND
;
;    ; ---- IF body (both true) ----
;    ...
;
; END_AND:
;


; ================================================================
; MODULE 4: OR - general pattern (two conditions)
;
; C:  if (cond1 || cond2) { ... }
;
; Pattern: test cond1, pass -> IF_BODY
;          test cond2, pass -> IF_BODY
;          JMP ELSE_OR_END
; IF_BODY:
;          ...
; ELSE_OR_END:
; ================================================================
;
;    CMP AL, VAL1
;    JE  IF_OR_BODY
;    CMP AL, VAL2
;    JE  IF_OR_BODY
;    JMP OR_SKIP              ; neither true
;
; IF_OR_BODY:
;    ...
;
; OR_SKIP:
;


; ================================================================
; MODULE 5: AND - valid digit ('0' to '9')
;
; C:  if (AL >= '0' && AL <= '9')
; ================================================================
;
;    CMP AL, '0'
;    JB  NOT_DIGIT            ; below '0'
;    CMP AL, '9'
;    JA  NOT_DIGIT            ; above '9'
;
;    ; valid digit
;    ...
;    JMP DIGIT_DONE
;
; NOT_DIGIT:
;    ; invalid
;
; DIGIT_DONE:
;


; ================================================================
; MODULE 6: AND - lowercase letter ('a' to 'z')
;
; C:  if (AL >= 'a' && AL <= 'z')
; ================================================================
;
;    CMP AL, 'a'
;    JL  END_LOWER
;    CMP AL, 'z'
;    JG  END_LOWER
;
;    ; is lowercase
;    MOV DL, AL
;    MOV AH, 02H
;    INT 21H
;
; END_LOWER:
;


; ================================================================
; MODULE 7: OR - vowel (a, e, i, o, u)
;
; C:  if (c=='a' || c=='e' || c=='i' || c=='o' || c=='u')
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
;    JMP NOT_VOWEL
;
; IS_VOWEL:
;    ; vowel body
;    JMP VOWEL_DONE
;
; NOT_VOWEL:
;    ; consonant body
;
; VOWEL_DONE:
;


; ================================================================
; MODULE 8: OR - Enter or Space to stop
;
; C:  if (AL == CR || AL == SPACE) stop
; ================================================================
;
;    CMP AL, 0DH              ; Enter
;    JE  STOP_NOW
;    CMP AL, 20H              ; Space
;    JE  STOP_NOW
;    JMP KEEP_READING
;
; STOP_NOW:
;    ...
;
; KEEP_READING:
;    ...
;


; ================================================================
; MODULE 9: AND with number range (1 to 9)
;
; C:  if (n >= 1 && n <= 9)
; ================================================================
;
;    CMP AL, 1
;    JB  OUT_OF_RANGE
;    CMP AL, 9
;    JA  OUT_OF_RANGE
;
;    ; in range 1..9
;    ...
;    JMP RANGE_OK
;
; OUT_OF_RANGE:
;    ...
;
; RANGE_OK:
;


; ================================================================
; MODULE 10: AND + OR combined (exam style)
;
; C:  if (AL is uppercase) OR (AL is lowercase) -> letter
;
; First check OR of two AND groups:
;   (AL>='A' && AL<='Z')  OR  (AL>='a' && AL<='z')
; ================================================================
;
;    ; check uppercase AND
;    CMP AL, 'A'
;    JL  TRY_LOWER
;    CMP AL, 'Z'
;    JLE IS_LETTER            ; 'A'..'Z' -> letter
;
; TRY_LOWER:
;    CMP AL, 'a'
;    JL  NOT_LETTER
;    CMP AL, 'z'
;    JG  NOT_LETTER
;
; IS_LETTER:
;    ; is A-Z or a-z
;    JMP LETTER_DONE
;
; NOT_LETTER:
;    ; not a letter
;
; LETTER_DONE:
;


; ================================================================
; CHEAT SHEET
; ================================================================
;
;  AND (both must be true):
;    CMP ... first condition
;    Jxx END_IF               ; fail -> skip
;    CMP ... second condition
;    Jxx END_IF               ; fail -> skip
;    ; IF body
;  END_IF:
;
;  OR (at least one true):
;    CMP ... condition 1
;    JE  IF_BODY
;    CMP ... condition 2
;    JE  IF_BODY
;    JMP SKIP
;  IF_BODY:
;    ...
;  SKIP:
;
;  Jump pairs (after CMP A, B):
;    >=   JNGE skip    (not >=)
;    <=   JNLE skip    (not <=)
;    >    JLE skip     (not >)
;    <    JGE skip     (not <)
;    ==   JNE skip
;    !=   JE  skip
;


; ================================================================
; FULL RUNNABLE EXAMPLE 1: Uppercase AND (Example 6-6)
; Copy to new .asm file to assemble and run
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
;     INT 21H
;
;     CMP AL, 'A'
;     JL  END_IF
;     CMP AL, 'Z'
;     JG  END_IF
;
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;
; END_IF:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;


; ================================================================
; FULL RUNNABLE EXAMPLE 2: y or Y OR (Example 6-7)
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
;     INT 21H
;
;     CMP AL, 'Y'
;     JE  THEN
;     CMP AL, 'y'
;     JE  THEN
;     JMP ELSE_
;
; THEN:
;     MOV DL, AL
;     MOV AH, 02H
;     INT 21H
;     JMP DONE
;
; ELSE_:
;     MOV AH, 4CH
;     INT 21H
;
; DONE:
;     MOV AH, 4CH
;     INT 21H
; MAIN ENDP
; END MAIN
;
