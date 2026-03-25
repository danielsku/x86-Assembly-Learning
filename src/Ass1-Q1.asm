TITLE Q1

; Name: Daniel Skurivdas
; Date: 10/1/2025
; ID: 110165070

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    
	; data declarations go here
    ; Note. I did not use A, B, C, etc as variable names because
    ; C is a reserved keyword and to keep it consistent
    ; I created variables aVal, bVal, etc.


    ; Declare and initialize the memory variable A to 32-bit signed integer value -543210
    aVal SDWORD -543210
    ; and variable B to 16-bit signed integer value -3210. 
    bVal SWORD -3210

    ; Declare 32-bit signed integer C
    cVal SDWORD ?          ; Read in values from keyboard -43210
    ; Declare 8-bit signed integer d
    dVal SBYTE ?           ; Read in values rom keyboard -10
    ; Variable Z is declared as a 32-bit signed integer
    zVal SDWORD ?          ; Calculated
    
    ; Display messages
    askC BYTE "What is the value of C? ", 0
    askD BYTE "What is the value of D? ", 0
    disE BYTE "Z = (A - B) - (C - D)", 0

    ; Three spaces, semi-colon, three spaces, to be used in display later
    sepe BYTE '   ;   ', 0

.code
main PROC
; --- INPUT ---
    ; ***
    ; Note. after user enters their input : 
    ; What is the value of C? -43210 <-- The value is already displayed beside the (i.e. to the right of) message when user presses enter after input
	mov edx, OFFSET askC
    call WriteString
    call ReadInt
    mov cVal, eax

    ; Same point as in previous input
    mov edx, OFFSET askD
    call WriteString
    call ReadInt
    mov dVal, al

; --- DISPLAY ---
    ; Display “Z = (A - B) - (C - D)” alone in a single line. 
    mov edx, OFFSET disE
    call WriteString
    call Crlf

    ;Display the values of all the variables A, B, C, D together in the next line each separated by 3 spaces and a semicolon and 3 spaces again. 

    mov eax, aVal
    call WriteInt

    mov edx, OFFSET sepe
    call WriteString

    movsx eax, bVal
    call WriteInt

    mov edx, OFFSET sepe
    call WriteString

    mov eax, cVal
    call WriteInt

    mov edx, OFFSET sepe
    call WriteString

    movsx eax, dVal
    call WriteInt
    call Crlf

    ; Display empty line
    call Crlf

; --- CALCULATIONS

    mov eax, aVal
    movsx ebx, bVal
    sub eax, ebx

    mov edx, cVal
    movsx ecx, dVal
    sub edx, ecx

    sub eax, edx

    mov zVal, eax
    
; --- FINAL DISPLAY --- 

   ; Display the final result contained in variable Z, in binary, then in decimal, and then in hexadecimal; each in a separate line.
    mov eax, zVal
    call WriteBin
    call Crlf
    call WriteInt
    call Crlf
    call WriteHex

	exit

main ENDP
END main
