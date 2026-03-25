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
    
    vector DWORD 50 DUP(?)
    vesize BYTE -1

    sum DWORD 0
    total DWORD 0

    i DWORD 0
    j DWORD 0
    min DWORD 0

    rv BYTE 'Y'


    comma BYTE ", ", 0
    space BYTE "  ", 0
    conja  BYTE " and ", 0

    sask BYTE "What is the size N of Vector?> ",0
    negs BYTE "Size must be positive or zero", 0
    aska BYTE "What are the ", 0
    askb BYTE " values in Vector?> ", 0
    svec BYTE "Size of Vector is N = ", 0

    vect BYTE "Vector = ", 0

    sumn BYTE "Sum of all the negative values in Vector is : Sum = ", 0
    nump BYTE "The number of all the positive values in Vector is: Count = ", 0

    ij   BYTE "Please give me two values I and J such that 1 <= I <= J <= N> ", 0
    inva BYTE "Invalid I or J", 0
    idis BYTE "I = ", 0
    conjb BYTE " and, ", 0
    jdis BYTE "J = ",0
    minva BYTE "the minimum value between position ", 0
    minvb BYTE " of Vector is: Minimum = ", 0

    ypal BYTE "Vector is a palindrom because it reads the same way in both directions.", 0
    npal BYTE "Vector is NOT a palindrome", 0

    repl BYTE "Repeat with a new Vector of different size and/or content?> ", 0

.code
main PROC
	
    again : 
        call Crlf

        ; Reset sum and total each iteration
        mov sum, 0
        mov total, 0


        mov edx, OFFSET sask
        call WriteString
        call ReadInt
        mov vesize, al

        ;   While loop that will run until user enters valid array size

        top: cmp vesize, 0
            jge nexta    ;  Remove line if other comented conditions below are active
            ;jb cont
            ;cmp vesize, 50
            ;jbe nexta
            ;cont:

            mov edx, OFFSET negs
            call WriteString
            call Crlf

            mov edx, OFFSET sask
            call WriteString
            call ReadInt

            mov vesize, al     ; Move size into size variable
            jmp top
        nexta:

        ; Skip whole program if size = 0
        cmp vesize, 0
        je skipall

        ; Returns array to size to 50 if it is greater than 50
        cmp vesize, 50
        jb nextb
        mov vesize, 50
        nextb:

        ; What are the 'size' values in Vector?
        mov edx, OFFSET aska
        call WriteString
        movzx eax, vesize
        call WriteDec
        mov edx, OFFSET askb
        call WriteString
        call Crlf 

        ; For loop that will assign value to every array element
        movzx ecx, vesize 
        mov edi, OFFSET vector

        elements : 
            call ReadInt
            mov [edi], eax
            add edi, TYPE vector
            loop elements

        call Crlf

        ; Display size of array
        mov edx, OFFSET svec
        call WriteString
        movzx eax, vesize
        call WriteDec
        call Crlf



        ; Loop through all elements in array
        mov edx, OFFSET vect
        call WriteString

        movzx ecx, vesize 
        mov edi, OFFSET vector
        mov edx, OFFSET space
        element : 
           mov eax, [edi]
           call WriteInt
           call WriteString
           add edi, TYPE vector        
           loop element

        call Crlf
        call Crlf

        ; Loops thorugh all elements, total++ if positive, sum+= if negative number
        movzx ecx, vesize 
        mov edi, OFFSET vector
        mov eax, [edi]
        sumtotal : 
            mov eax, [edi]
            cmp eax, 0
            jle is_negative
            inc total
            jmp end_sumtotal
            is_negative: 
                add sum, eax
            end_sumtotal:
                add edi, TYPE vector
                loop sumtotal

        ; Display sum of negatives, total of positives
        mov edx, OFFSET sumn 
        mov eax, sum
        call WriteString
        call WriteInt
        call Crlf

        mov edx, OFFSET nump
        mov eax, total
        call WriteString
        call WriteDec
        call Crlf

        call Crlf

        ; find min
        mov edx, OFFSET ij
        call WriteString
        call Crlf
        jmp start_ij


        ; Get i and j, verify the inputs 
        find_ij:
            call Crlf
            mov edx, OFFSET inva
            call WriteString
            call Crlf

            start_ij:

            
            call ReadInt
            mov i, eax

            call ReadInt
            mov j, eax

            mov ebx, i

            cmp ebx, 1
            jl find_ij      ; Try again if i < 1

            mov ebx, j

            cmp ebx, i
            jl find_ij      ; Try again if j < i

            cmp bl, vesize   ; try gain if N < j
            jg find_ij

        call Crlf

        ; Loop to find min
        mov ecx, j        
        sub ecx, i

        
        mov edi, OFFSET vector
        mov eax, i
        dec eax
        add eax, eax
        add eax, eax
        add edi, eax


        mov eax, [edi]
        mov min, eax
        add edi, TYPE vector

        ; if j == i, then jump then skip loop
        mov ebx, j
        cmp ebx, i 
        je iej
        

        minimum:
            mov eax, [edi]
            cmp eax, min
            jge min_end
            mov min, eax
            min_end:
                add edi, TYPE vector
                loop minimum
        
        iej :  
        

        mov edx, OFFSET idis
        call WriteString
        mov eax, i
        call WriteDec

        mov edx, OFFSET conja
        call WriteString

        mov edx, OFFSET jdis
        call WriteString
        mov eax, j
        call WriteDec

        mov edx, OFFSET conjb
        call WriteString
        call Crlf

        mov edx, OFFSET minva
        call WriteString
        mov eax, i
        call WriteDec
        mov edx, OFFSET conja
        call WriteString
        mov eax, j
        call WriteDec
        mov edx, OFFSET minvb
        call WriteString
        
        mov eax, min
        call WriteInt
        call Crlf
        call Crlf
        
        ; Pallindrome

        mov edi, OFFSET vector ; Lowest index (First)

        mov esi, OFFSET vector ; highest index (Last)

        ; ESI is highest index, EDI is lowest
        ; Access last element in array, assign it to esi
        movzx eax, vesize
        dec eax
        add eax, eax
        add eax, eax
        add esi, eax

        pallindrome: 

            cmp edi, esi
            jae is_pall

        ; DEBUGGING
            ; mov eax, [esi]
            ; call WriteInt
            ; call Crlf
            ; mov eax, [edi]
            ; call WriteInt
            ; call Crlf
        ; DEBUGGING

            mov eax, [edi]
            mov ebx, [esi]
            cmp eax, ebx
            jne not_pall

            add edi, TYPE vector
            sub esi, TYPE vector
            jmp pallindrome

        is_pall: 
            mov edx, OFFSET ypal
            call WriteString
            call Crlf
            jmp next

        not_pall: 
            mov edx, OFFSET npal
            call WriteString
            call Crlf
        
        next:
            call Crlf
            mov edx, OFFSET repl
            call WriteString
            ; Double ReadString to absorb \n too
            call ReadChar
            mov edx, eax

            call WriteChar
    
            cmp al, 'Y'
            je again

            cmp al, 'y'
            je again

    skipall:

	exit

main ENDP
END main
