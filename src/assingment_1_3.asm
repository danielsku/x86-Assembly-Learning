TITLE

; Name: 
; Date: 
; ID: 
; Description: 

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
	
    mov edx, OFFSET ask
    call WriteString

	call ReadHex
    mov littleEndian, eax

    mov cl, BYTE PTR littleEndian + 3
    mov BYTE PTR bigEndian, cl

    mov cl, BYTE PTR littleEndian + 2
    mov BYTE PTR bigEndian + 1, cl

    mov cl, BYTE PTR littleEndian + 1
    mov BYTE PTR bigEndian + 2, cl

    mov cl, BYTE PTR littleEndian
    mov BYTE PTR bigEndian + 3, cl

    mov edx, OFFSET txt2
    call WriteString

    movzx eax, BYTE PTR bigEndian
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    movzx eax, BYTE PTR bigEndian + 1
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    movzx eax, BYTE PTR bigEndian + 2
    call WriteHex

    mov edx, OFFSET comma
    call WriteString

    movzx eax, BYTE PTR bigEndian + 3
    call WriteHex
    call Crlf

    mov edx, OFFSET txt1
    call WriteString

    mov eax, littleEndian
    call WriteHex
    call Crlf

	call DumpRegs ; displays registers in console

	exit

main ENDP
END main
