TITLE Q3

; Name: Daniel Skurivdas
; Date: 10/1/2025

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    
    bigEndian  BYTE ?, ?, ?, ? 
    littleEndian DWORD ?

    ask BYTE "Please enter a number : ", 0

    txt1 BYTE "bigEndian = ", 0
    txt2 BYTE "littleEndian = ", 0
    comma BYTE ", ", 0

.code
main PROC
	

; ----- Read from user -----

    mov edx, OFFSET ask
    call WriteString

	call ReadHex
    mov littleEndian, eax

; Put the reverse of littleEndian into bigEndian

    mov ecx, littleEndian + 3
    mov bigEndian, cl

    mov ecx, littleEndian + 2
    mov bigEndian + 1, cl

    mov ecx, littleEndian + 1
    mov bigEndian + 2, cl

    mov ecx, littleEndian
    mov bigEndian + 3, cl

; -------- RESULTS ---------
    
    ; Move 0h into eax to make output clean
    mov eax, 0h

    mov edx, OFFSET txt1
    call WriteString

    mov al, bigEndian
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    mov al, bigEndian + 1
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    mov al, bigEndian + 2
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    mov al, bigEndian + 3
    call WriteHex
    call Crlf

    mov edx, OFFSET txt2
    call WriteString
    

    mov eax, littleEndian
    call WriteHex
    call Crlf

	exit

main ENDP
END main
