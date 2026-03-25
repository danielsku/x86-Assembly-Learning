TITLE Q2

; Name: Daniel Skurivdas
; Date: 10/1/2025

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    
    bigEndian BYTE 12h, 34h, 0ABh, 0CDh

    littleEndian DWORD ? 

    txt1 BYTE "bigEndian = ", 0
    txt2 BYTE "littleEndian = ", 0
    comma BYTE ", ", 0


.code
main PROC

    ; Idea is to reverse the positions in bigEndian to make it in little Endian order
    ; put that into littleEndian variable, and swap bigEndian positions again
    ; to return the array into bigEndian order once more

    ; Let p be position
    ; To reverse array bigEndian : 
    ; We need to swap p0 with p3
    ; Then p1 with p2
    ; p0p1p2p3 --> p3p2p1p0 (littleEndian)


    ; exchange p0 and p3
    mov al, bigEndian
    xchg al, bigEndian + 3
    mov bigEndian, al

    ; exchange p1 and p2
    mov al, bigEndian + 1
    xchg al, bigEndian + 2
    mov bigEndian + 1, al

    ; Copy reversed bigEndian into littleEndian
    ; littleEndian accesses 4 bytes before itself to access all of bigEndian
    mov ecx, littleEndian - 4
    mov littleEndian, ecx

    ; Reverse bigEndian array again so it returns to bigEndian order

    ; exchange p0 and p3
    mov al, bigEndian
    xchg al, bigEndian + 3
    mov bigEndian, al

    ; exchange p1 and p2
    mov al, bigEndian + 1
    xchg al, bigEndian + 2
    mov bigEndian + 1, al
    
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
