.MODEL SMALL
.STACK 100H

.DATA
    ; Declare a byte array (string) in the data segment
    ; Each DB byte is one array element (its ASCII code, not the decimal number printed)
    ; 13 = CR (carriage return), 10 = LF (line feed) -> newline effect, NOT the text "13" or "10"
    MY_ARRAY DB 'Hello from array!', 13, 10

    ARRAY_SIZE EQU $ - MY_ARRAY    ; total bytes: string length + 2 (includes 13 and 10)


.CODE
MAIN PROC

    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX

    ; Print array using a loop
    MOV SI, OFFSET MY_ARRAY    ; SI points to first element
    MOV CX, ARRAY_SIZE         ; CX = loop counter (array length)

PRINT_LOOP:
    MOV DL, [SI]               ; get current array element
    MOV AH, 02H                ; DOS function: display character
    INT 21H

    INC SI                     ; move to next element
    LOOP PRINT_LOOP            ; CX--; repeat until CX = 0

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
