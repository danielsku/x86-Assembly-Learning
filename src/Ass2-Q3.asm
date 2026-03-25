TITLE

; Name: Skurvidas, Daniel
; Date: October 19, 2025

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    
    input BYTE 129 DUP(?) ; To allow at most 128 characters + one null terminator
    total BYTE 0

    nUp BYTE 0
    

    dis BYTE "Enter a string of at most 128 characters : ", 0
    disf BYTE "Here it is, with all lowercases and uppercases flipped, and in reverse order: ", 0

    updis BYTE "There are ", 0
    updis2 BYTE " upper-case letters after conversion.", 0

    alldis BYTE " characters in the string.", 0

.code
main PROC
	
    mov edx, OFFSET dis
    call WriteString

    mov edx, OFFSET input
    mov ecx, SIZEOF input

    call ReadString
    ; mov total, al ; This is also possible, after every ReadString call, the # of characters read is in eax
    call Crlf

    mov esi, OFFSET input

    ; Loop to count the number of characters
    mov ecx, 0
    count: 
        mov al, [esi]
        cmp al, 0
        je next

        inc ecx
        inc esi
        jmp count
    next:
    
    ; mov byte ptr [esi], 0
    mov total, cl

    ; Loop to reverse, switch cases, and count upper cases

    mov esi, OFFSET input ; Left-most char
    mov edi, OFFSET input ; Right-most char
    movzx eax, total
    add edi, eax   
    dec edi

    ; call DumpRegs ; For Debugging
   
    mov ebx, 0
    mov eax, 0
    mov ecx, 0


    reverse: 
        cmp esi, edi
        ja end_reverse 
        je right

        mov al, [esi]

        ; Checks if esi is uppercase 
        cmp al, 'A'
        jl right

        cmp al, 'Z'
        jle uptolow_left

        ; esi is lowercase
        cmp al, 'a'
        jl right

        cmp al, 'z'
        jg right

        lowtoup_left: 
            sub al, 20h
            mov [esi], al
            add ebx, 1
            jmp right

        uptolow_left: 
            add al, 20h
            mov [esi], al

        right:
            ; Checks if edi is uppercase 

            mov al, [edi]

            cmp al, 'A'
            jl reverse_next

            cmp al, 'Z'
            jle uptolow_right

            ; edi is lowercase
            cmp al, 'a'
            jl reverse_next
            cmp al, 'z'
            jg reverse_next

            lowtoup_right: 
                sub al, 20h
                mov [edi], al
                add ebx, 1
                jmp reverse_next

            uptolow_right: 
                add al, 20h
                mov [edi], al

        reverse_next:
            mov al, [esi]
            xchg [edi], al
            mov [esi], al

            inc esi
            dec edi 
            
            jmp reverse       

        end_reverse:

    mov nUp, bl

    ; Display changed in put
    mov edx, OFFSET disf
    call WriteString
    call Crlf

    mov edx, OFFSET input
    call WriteString
    call Crlf
    call Crlf

    ; Display number of uppercase
    mov edx, OFFSET updis
    call WriteString

    movzx eax, nUp
    call WriteDec

    mov edx, OFFSET updis2
    call WriteString
    call Crlf

    ; Display number of Characters

    mov edx, OFFSET updis
    call WriteString

    movzx eax, total
    call WriteDec

    mov edx, OFFSET alldis
    call WriteString
    call Crlf




;	call DumpRegs ; displays registers in console

	exit

main ENDP
END main
