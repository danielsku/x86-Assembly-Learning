TITLE

; Name: Skurvidas, Daniel

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    
	vector DWORD 20 DUP(?)
    vesize SDWORD 42         ; Set to 42 for error checking
                            ; A properly defined size cannot be more
                            ; than 20, so 42 should work fine.
                            ; It's also SWORD to check for 
                            ; incorrect negative sizes
    baseval DWORD ?
    choice BYTE ?

    sepe BYTE "  ", 0
    
    msg1 BYTE "What do you want to do now? > ", 0

    msgs BYTE "What is the size N of Vector? > ", 0
    msg2 BYTE "What are the ", 0
    msgt BYTE " values in Vector? > ", 0

    msg3 BYTE "Size of Vector is N = ", 0
    msgv BYTE "Vector = ", 0

    empt BYTE "Stack is empty",0
    noem BYTE "Stack not empty",0

    msg4 BYTE "Vector is ", 0 
    msg5 BYTE "Stack is ", 0
    
    arts BYTE " before ArrayToStack", 0
    aats BYTE " after ArrayToStack", 0

    star BYTE " before StackToArray", 0
    asta BYTE " after StackToArray", 0

    strv BYTE " before StackReverse", 0
    astr BYTE " After StackReverse", 0


    errs BYTE "Error - Create an array first", 0
    erre BYTE "Error - Stack is full: Cannot create new Array - Empty Stack first", 0

    erra BYTE "Error - Stack is full: Cannot perform ArrayToStack", 0
    errb BYTE "Error - Stack is empty: Cannot perform StackToArray", 0
    errc BYTE "Error - Stack is full: Cannot perform StackReverse", 0

    erme BYTE "Please choose a valid option", 0
    term BYTE "I am exiting... Thank you Honey... and Get lost...", 0

.code
main PROC
	
    mov baseval, esp ; Save stack pointer default value
    sub baseval, 4   ; When we call the pcheck procedure : 
                     ; the procedure is going to take space on stack
                     ; to offset this, we sub 4 to baseval
                     ; So when proc is called, it will return
                     ; "Stack is empty" if it's the only procedure
                     ; on the stack

    again: 
        
        mov edx, OFFSET msg1
        call WriteString

        menu:
            call ReadInt
            mov choice, al
            cmp choice, 0   ; Jump to set a new vector & size
            je choice0
            cmp choice, 1   ; ArrayToStack
            je choice1
            cmp choice, 2   ; StackToArray
            je choice2
            cmp choice, 3   ; StackReverse
            je choice3
            cmp choice, -1  ; Exit
            je theend
            mov edx, OFFSET erme
            call WriteString
            call crlf
            jmp menu

; ---------------- Option 0 ----------------
        choice0:

            call empty  ; Check if stack is full, call error if it is
            cmp ebx, 0          
            jne continue0
            mov edx, OFFSET erre
            call WriteString
            call crlf
            call crlf
            jmp again
            continue0:
            
            ; The reason for the check above is to not create any array
            ; when stack is full so that there is no error clearing 
            ; the stack into an array of different size which could
            ; access an out of bounds stack index.

            mov edx, OFFSET msgs
            call WriteString
            call ReadDec        

            cmp eax, 20
            jle setsize
            mov eax, 20             ; if number > 20, then size = 20
            jmp validset
            setsize:
                cmp eax, 0
                jg validset
                mov eax, 1          ; if number <=0, then size = 1
            validset:
                mov vesize, eax

            ; Note. I could do an error checking algorithm, but
            ; for simplicity, I added default max and min values instead
            ; where if user enters number > 20, then size = 20
            ; if user enters number <= 0, then size = 1 

            ; Get all elements
            mov edx, OFFSET msg2
            call WriteString
            mov eax, vesize
            call WriteDec
            mov edx, OFFSET msgt
            call WriteString
            call crlf


            mov ecx, vesize
            mov esi, OFFSET vector
            getElements:
                call ReadInt
                mov [esi], eax
                add esi, TYPE vector
                loop getElements

            call crlf

            ; Print all elements
            mov edx, OFFSET msg3
            call WriteString
            mov eax, vesize
            call WriteDec

            call crlf
            call crlf

            mov edx, OFFSET msgv
            call WriteString

            
            mov ecx, vesize
            mov esi, 0
            mov edx, OFFSET sepe
            call display

        jmp next

; ---------------- Option 1 -----------------
        choice1:


        ; Error checking beforehand

            cmp vesize, 42
            jne validsize
            mov edx, OFFSET errs
            call WriteString
            call crlf
            call crlf
            jmp again

            validsize:

            call empty  ; Check if stack is full, call error if it is
            cmp ebx, 0
            jne continue
            mov edx, OFFSET erra
            call WriteString
            call crlf
            call crlf
            jmp again
            continue:

    ; Display all elements before ArrayToStack

        mov edx, OFFSET msg4
        call WriteString

        mov ecx, vesize
        mov esi, 0
        mov edx, OFFSET sepe
        call display

        mov edx, OFFSET arts
        call WriteString

        call crlf

    ; Display all elements (in vector + stack) after ArrayToStack
        mov edx, OFFSET msg5
        call WriteString

        mov esi, OFFSET vector
        mov ecx, vesize
        dec ecx
        
        advanceLoop: ; Advance to last element
            add esi, TYPE vector
            loop advanceLoop

        mov ecx, vesize
        mov edx, OFFSET sepe
        ArrayToStack:                   ; Pushing elements to stack
            mov eax, [esi]
            call WriteDec
            call WriteString
            push [esi]
            mov DWORD PTR [esi], 0
            sub esi, TYPE vector
            loop ArrayToStack

        mov edx, OFFSET aats
        call WriteString

        call crlf

        mov edx, OFFSET msg4
        call WriteString

        mov ecx, vesize                 ; Display vector again
        mov esi, 0
        mov edx, OFFSET sepe
        call display

        mov edx, OFFSET aats
        call WriteString

        jmp next
; ---------------- Option 2 -----------------

        choice2: 

            ; Error checking beforehand

            cmp vesize, 42
            jne validsize2
            mov edx, OFFSET errs
            call WriteString
            call crlf
            call crlf
            jmp again

            validsize2:

            call empty  ; Check if stack is empty, call error if it is
            cmp ebx, 1
            jne continue2
            mov edx, OFFSET errb
            call WriteString
            call crlf
            call crlf
            jmp again
            continue2:

            
            mov edx, OFFSET msg5
            call WriteString

            mov edx, OFFSET sepe
            mov esi, OFFSET vector

            mov ecx, vesize

            StackToArray: ;pop all elements of stack into vector
                pop eax
                mov DWORD PTR [esi], eax
                add esi, TYPE vector
                loop StackToArray


            mov edi, OFFSET vector
            mov ecx, vesize
            dec ecx

            advanceLoop2: ; Advance to last element
                add edi, TYPE vector
                loop advanceLoop2

            mov ecx, vesize

            printBack: ; print all elements as they were on stack
                mov eax, [edi]
                call WriteDec
                call WriteString
                sub edi, TYPE vector
                loop printBack

            mov edx, OFFSET star
            call WriteString

            call crlf

            mov edx, OFFSET msg4
            call WriteString
            
            mov ecx, vesize ; Print elements vector
            mov esi, 0
            mov edx, OFFSET sepe
            call display

            mov edx, OFFSET asta
            call WriteString

        jmp next

; ---------------- Option 3 -----------------
        choice3:

            ; Error checking beforehand

            cmp vesize, 42
            jne validsize3
            mov edx, OFFSET errs
            call WriteString
            call crlf
            call crlf
            jmp again

            validsize3:

            call empty  ; Check if stack is empty, call error if it is
            cmp ebx, 0
            jne continue3
            mov edx, OFFSET errc
            call WriteString
            call crlf
            call crlf
            jmp again
            continue3:

            mov edx, OFFSET msg4
            call WriteString

            mov ecx, vesize ; Print elements vector
            mov esi, 0
            mov edx, OFFSET sepe
            call display

            mov edx, OFFSET strv
            call WriteString

            ; Push into stack
            mov esi, OFFSET vector
            mov ecx, vesize
            mov edx, OFFSET sepe

            ArrayToStack2:                   ; Pushing elements to stack
                mov eax, [esi]
                push [esi]
                mov DWORD PTR [esi], 0
                add esi, TYPE vector
                loop ArrayToStack2
            
            call crlf
            call crlf
            call pcheck
            call crlf

            mov esi, OFFSET vector
            mov ecx, vesize
    
            StackToArray2:                      ;pop all elements of stack into vector
                pop eax
                mov DWORD PTR [esi], eax
                add esi, TYPE vector
                loop StackToArray2

            call crlf

            mov edx, OFFSET msg4
            call WriteString

            mov ecx, vesize ; Print elements vector
            mov esi, 0
            mov edx, OFFSET sepe
            call display

            mov edx, OFFSET astr
            call WriteString

        
        

        next: ; After any option, we jump to next
            call crlf
            call crlf
           
            call pcheck

            call crlf
            call crlf

        

    jmp again

    theend:

        call crlf
        mov edx, OFFSET term
        call WriteString
    
	exit

main ENDP
;------------------------------------
; pcheck
;
; Checks if the stack is empty, outputs if it is or not
; RECEIVES : esp --> current stack pointer
; RETURNS  : Nothing, output if stack is empty or not on console  
; REQUIRES : Nothing
;------------------------------------
pcheck PROC
    cmp baseval, esp
        jz isEmpty
            mov edx, OFFSET noem
            call WriteString
        jmp nexta
        isEmpty:
            mov edx, OFFSET empt
            call WriteString
        nexta:
    ret
pcheck ENDP
;------------------------------------
; empty
;
; Checks if the stack is empty, returns 1 if it is, 0 if not
; RECEIVES : esp --> current stack pointer
; RETURNS  : ebx = 1 if empty, ebx = 0 if not empty
; REQUIRES : Nothing
;------------------------------------
empty PROC
    cmp baseval, esp
        jz isEmpty
            mov edx, OFFSET noem
            mov ebx, 0
        jmp nexta
        isEmpty:
            mov edx, OFFSET empt
            mov ebx, 1
        nexta:
    ret
empty ENDP

;------------------------------------
; display
;
; displays all elements in a vector
; RECEIVES : ecx --> vector size, esi --> pointer first vector element, edx --> seperator
; RETURNS  : Nothing, displays all vector elements 
; REQUIRES : Nothing
;------------------------------------
display PROC uses eax edx esi
    printElements:
        mov eax, vector[esi]
        call WriteDec
        call WriteString
        add esi, TYPE vector
        loop printElements
    ret
display ENDP

END main
