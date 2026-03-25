TITLE

; Name: Skurvidas, Daniel


INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data

; Lab-51. Write a program which evaluates the expression R = (A * B) / (C * D) 
; when A, B, and C, D are 8-bit signed integers. 
    
	aVal SBYTE 10     ; Unitiliazed, could be any value really
    bVal SBYTE 8     ; Also, I added 'Val' after the letter to avoid using possible keywords
    cVal SBYTE 4
    dVal SBYTE 5

    rVal SBYTE ?     ; Variable to store results 

.code
main PROC
; -------------------------	

    mov al, cVal    ; AL = C
    imul dVal       ; AX = C * D
    mov bx, ax      ; BX = C * D (RIGHT SIDE)

; -------------------------

    mov al, aVal    ; AL = A
    imul bVal       ; AX = A * B (LEFT SIDE)

; -------------------------    

    CWD             ; Convert AX to DX:AX (WORD to DOUBLEWORD)
    idiv bx
    mov rVal, al

    call writeDec
    exit

main ENDP
END main
