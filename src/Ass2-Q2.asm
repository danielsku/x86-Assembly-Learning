TITLE

; Name: Skurvidas, Daniel
; ID: 110165070
; Date: October 19, 2025


INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data

    fibsize BYTE ?

    badMsg BYTE "Size must be non-negative. Please enter 0 or a positive integer: ",0
    input BYTE "N = ", 0
    fibdis BYTE "Fibonacci sequence with N = ", 0
    fibdis2 BYTE " is: ", 0
    space BYTE " ", 0



.code
main PROC
    
    mov edx, OFFSET input
    call WriteString

    ; Checks if N >= 0, reprompts if N < 0
    readN:
        call ReadInt            
        cmp eax, 0
        jl readN_invalid       
        mov fibsize, al
        jmp gotN

    readN_invalid:
        mov edx, OFFSET badMsg  
        call WriteString
        call Crlf
        jmp readN

    gotN:

    mov edx, OFFSET fibdis
    call WriteString

    call WriteDec

    mov edx, OFFSET fibdis2
    call WriteString

; Fib loop

    mov edx, OFFSET space
    
    cmp fibsize, 1
    je first

    cmp fibsize, 1
    jg rest
    
    cmp fibsize, 0
    je zeroth

    cmp fibsize, 0
    jl finish

    zeroth:
        mov eax, 0
        call WriteDec
        call WriteString
        jmp finish

    first:
        mov eax, 0
        call WriteDec
        call WriteString

        mov eax, 1
        call WriteDec
        call WriteString
        jmp finish

    rest:

    mov eax, 0
    call WriteDec
    call WriteString

    mov eax, 1
    call WriteDec
    call WriteString

    mov eax, 0  ; a
    mov ebx, 1  ; b
    mov esi, 0  ; extra

    movzx ecx, fibsize
    dec ecx

    fib : 

        mov eax, 0

        add eax, ebx
        add eax, esi

        mov esi, ebx
        mov ebx, eax
        
        call WriteDec
        call WriteString
        
        loop fib

    finish: 

	exit

main ENDP
END main
