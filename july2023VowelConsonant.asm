; ============================================================
; July 2023 CSE 316 (B1/B2) - Count vowels and consonants
;
; String: lowercase vowels and consonants only (hardcoded)
; Use loop to scan each character.
;
; Case 1: uyhitnae        -> Vowel: 4,  Consonant: 4
; Case 2: qwertykeyboards -> Vowel: 4,  Consonant: 11
; Case 3: eruiaaageruiaaag -> Vowel: 12, Consonant: 4
; ============================================================

.MODEL SMALL
.STACK 100H

.DATA
    ; Case 1
    TEXT DB 'uyhitnae$'
    ; Case 2: DB 'qwertykeyboards$'
    ; Case 3: DB 'eruiaaageruiaaag$'

    MSG_VOWEL DB 'Vowel Count: $'
    MSG_CONS  DB 'Consonant Count: $'

    VOWEL_CNT  DB 0
    CONSONANT_CNT DB 0

.CODE
MAIN PROC

    ; ---- MODULE: Init Data Segment ----
    MOV AX, @DATA
    MOV DS, AX

    ; ---- MODULE: Count vowels and consonants in string ----
    MOV SI, OFFSET TEXT
    MOV VOWEL_CNT, 0
    MOV CONSONANT_CNT, 0

SCAN_LOOP:
    MOV AL, [SI]
    CMP AL, '$'              ; end of string
    JE  SCAN_DONE

    ; check if AL is a vowel (a, e, i, o, u)
    CMP AL, 'a'
    JE  IS_VOWEL
    CMP AL, 'e'
    JE  IS_VOWEL
    CMP AL, 'i'
    JE  IS_VOWEL
    CMP AL, 'o'
    JE  IS_VOWEL
    CMP AL, 'u'
    JE  IS_VOWEL

    ; consonant
    INC CONSONANT_CNT
    JMP SCAN_NEXT

IS_VOWEL:
    INC VOWEL_CNT

SCAN_NEXT:
    INC SI
    JMP SCAN_LOOP

SCAN_DONE:

    ; ---- MODULE: Print "Vowel Count: " ----
    MOV DX, OFFSET MSG_VOWEL
    MOV AH, 09H
    INT 21H

    ; ---- MODULE: Print vowel count ----
    MOV AL, VOWEL_CNT
    CALL PRINT_NUMBER

    ; ---- MODULE: Newline ----
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    INT 21H

    ; ---- MODULE: Print "Consonant Count: " ----
    MOV DX, OFFSET MSG_CONS
    MOV AH, 09H
    INT 21H

    ; ---- MODULE: Print consonant count ----
    MOV AL, CONSONANT_CNT
    CALL PRINT_NUMBER

    ; ---- MODULE: Exit Program ----
    MOV AH, 4CH
    INT 21H

MAIN ENDP


; ---- MODULE: Print number 0-99 (AL = value) ----
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH DX

    MOV AH, 0
    MOV BL, 10
    DIV BL                   ; AL = tens, AH = ones

    OR  AL, AL
    JZ  PN_ONES_ONLY

    PUSH AX
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    POP AX

PN_ONES_ONLY:
    MOV AL, AH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    POP DX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN
