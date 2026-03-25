TITLE

; Name: Skurvidas, Daniel
; ID : 110165070

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data

	buffer BYTE 10 DUP(?)	; 8 hex characters + 'h' + null terminator
	isloaded BYTE 0			; Flag to check if buffer is loaded or not
    
	msg BYTE "What do you want to do, Lovely? ", 0
    msgdone BYTE "Thank you, Sweetey Honey Bun", 0
    msgleave BYTE "Get Lost, you Sweetey Honey Bun", 0

    err1 BYTE "ERROR : Wrong input, please enter digits only from 0 - F", 0
    err2 BYTE "ERROR : Your input is too big or hasn't ended with 'h' ", 0

.code
main PROC
	
    mov edx, OFFSET msg ; Asks user what they want to do
    call WriteString
    call ReadChar
    call WriteChar

    and al, 11011111b	; Convert input to uppercase

    wCheck:
        cmp al, 'W'
        jne rCheck

        ; ---- To clear crlf ----
        mov edx, OFFSET buffer
        mov ecx, 2
        call readString 
        ; ---- To clear crlf ----

        call ReadDec           ; Read unsigned 32-bit decimal from user

        ; Note. ReadDec reads characters from the keyboard, ignores leading whitespace,
        ; and stops when a non-decimal digit (0–9) is encountered.
        ; It returns the number formed by the digits read in EAX.

        ; Two things to note

        ; 1. If there is a non-decimal input, it will the digits up
        ; until that non-decimal character

        ; 2. If there is an overflow in the register i.e. the user
        ; entered a number bigger than what can fit in, it will 
        ; display 00000000h after HexOuput

        mov ebx, eax           ; load number into ebx
        
        call HexOutput

        ; Note.
        ; 1111 1110 0000 0001 1100 1000 0011 0111b = 4261529655 = FE01C837h

        mov edx, OFFSET msgdone
        call WriteString
        call crlf
        jmp ending

    rCheck:
        cmp al, 'R'
        jne next

        ; ---- To clear crlf ----
        mov edx, OFFSET buffer
        mov ecx, 2
        call readString 
        ; ---- To clear crlf ----

        call HexInput

        call crlf
        call WriteBin
        call crlf

        mov edx, OFFSET msgdone
        call WriteString
        call crlf
        jmp ending

    next:          
        call crlf
        mov edx, OFFSET msgleave
        call WriteString

        ending:

	exit

main ENDP

; We won't use 'uses' or 'popad'/'pushad', as this is a simple enough program

;------------------------------------
; HexOutput
;
; Displays the content of register EBX as a hexadecimal string
; RECEIVES : EBX containing some binary number
; RETURNS  : Nothing, console output of EBX content in hexadecimal format
; REQUIRES : N/A
;------------------------------------

HexOutput PROC

    mov edx, 0
    mov ecx, 8 ; Loop repeats 8 times, once for every nibble

    mov esi, 0
	mov edi, OFFSET buffer
    
    hexout:
        rol ebx, 4
        mov dl, bl
        and dl, 0Fh

        cmp dl, 10
        jge alpha
        ; Convert to numeric
        or dl, 00110000b
        jmp save
        alpha:
            ; Convert to Alpha
            sub dl, 9
            or dl, 01000000b
        save:
            mov BYTE PTR [edi + esi], dl 
            inc esi
        loop hexout

    mov BYTE PTR [edi + esi], 'h'
    mov edx, OFFSET buffer
    call WriteString
    call crlf

    ret
HexOutput ENDP

;------------------------------------
; HexInput
;
; Reads string from keyboard and
; loads the register EAX with the numerical value 
; of the hexadecimal string entered at the keyboard
; RECEIVES : N/A
; RETURNS  : converted binary to hex into EAX and EBX
; REQUIRES : N/A
;------------------------------------

HexInput PROC

	xor ebx, ebx 	; EBX will hold result temporarily
    xor eax, eax    ; EAX will also hold results as per instructions

	mov ecx, 10 			; Maximum number characters buffer can hold
	mov edx, OFFSET buffer 	; Where input is to be read into
	call ReadString 		; Read hex string from user

	mov esi, 0
	mov edi, OFFSET buffer

	next_char:
        mov al, [edi + esi] ; Load current character

        cmp al, 'h'	; 'h' is the last thing we see in hexadecimal input
		je ending

        cmp al, 0
        je wrongEnd


        numCheck:
            cmp al, '0'
            jl wrongInput      ; if less than 0 char, error

            cmp al, '9'
            jg alphaCheck
            jmp isNumber

        alphaCheck:
            ; convert lowercase letters to uppercase
            and al, 11011111b

            cmp al, 'A'
            jl wrongInput      ; if between '9' - 'A', error

            cmp al, 'F'
            jg wrongInput      ; if greater than 'F', error
            jmp isAlpha

        isNumber:
            and al, 00001111b ; Mask, only use pertinent nibble
            jmp combine

        isAlpha:
            and al, 00001111b ; Mask, only use pertinent nibble
            add al, 9
            jmp combine

        combine:
            shl ebx, 4         ; Left shit EBX by 4 bits
            or ebx, eax        ; move AL into EAX implicitly
            inc esi
            jmp next_char

        wrongInput:
            xor ebx, ebx
            mov edx, OFFSET err1
            call WriteString
            call crlf
            jmp ending

        wrongEnd:
            xor ebx, ebx
            mov edx, OFFSET err2
            call WriteString
            call crlf 
            jmp ending

        jmp next_char

    ending: 

    mov eax, ebx
    call crlf

    ret

HexInput ENDP

END main

