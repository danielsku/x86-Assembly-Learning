TITLE

; Name: Skurvidas, Daniel
; ID: 11065070

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib


; ******NOTE*******, I exclude this program's file from windows defender to run it on my computer
; If the program might not be able to run, you might have to do the same
.data
    
	; Lab-51. Write a program which evaluates the expression R = (A * B) / (C * D) 
    ; when A, B, and C, D are 8-bit signed integers. 
    
	aVal SBYTE 10    ; could be any value really, but I added these for testing
    bVal SBYTE -8    ; Also, I added 'Val' after the letter to avoid using possible keywords
    cVal SBYTE 4
    dVal SBYTE 5

    rVal SBYTE ?     ; Variable to store results 
                     ; With these values, result should be -4

.code
main PROC
; -------------------------	

    movsx eax, cVal     ; EAX = C (C should be withing AL anyways
    imul dVal           ; AX = C * D
    mov bx, ax          ; BX = C * D (RIGHT SIDE)

; -------------------------

    mov al, aVal        ; AL = A
    imul bVal           ; AX = A * B (LEFT SIDE)

; -------------------------    

    CWD                 ; Convert AX to DX:AX
    idiv bx             ; (A * B)/(C * D)
    mov rVal, al

    ; Show results to screen
    movsx eax, rVal
    call writeInt

	exit

main ENDP
END main