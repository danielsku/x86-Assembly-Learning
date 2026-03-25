TITLE

; Name: Skurvidas, Daniel
; ID: 11065070


INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib	
INCLUDELIB user32.lib

.data
    
	aVal DWORD 0
	bVal DWORD 0

	msgA BYTE "Please enter A : ", 0
	msgB BYTE "Please enter B : ", 0
	msgG BYTE "Greatest Common divisor is : ", 0


.code
main PROC
	mov edx, OFFSET msgA
	call WriteString
	call ReadDec
	call crlf
	mov aVal, eax

	mov edx, OFFSET msgB
	call WriteString
	call ReadDec
	call crlf
	mov bVal, eax
 
	push aVal
	push bVal
	call gcd

	mov edx, OFFSET msgG
	call WriteString
	call WriteDec
	call crlf



	exit
main ENDP
;------------------------------------
; Greatest Common Divisor (GCD)
;
; RECEIVES : [ebp + 8] = A, [ebp + 12] = B
; RETURNS  : eax = GCD(A, B)
;------------------------------------
b_param EQU [ebp + 12]
a_param EQU [ebp + 8]
gcd PROC
	push ebp
	mov ebp, esp

	mov ebx, b_param
	cmp ebx, 0
	ja L1	; Continue to next
	mov eax, a_param
	jmp L2

	L1: mov eax, a_param
		cdq
		div ebx
		push edx	; PUSH b
		push b_param 	; PUSH a mod b
		call gcd
		add esp, 8	; C convetion

	L2: pop ebp
		ret 
gcd ENDP
END main
