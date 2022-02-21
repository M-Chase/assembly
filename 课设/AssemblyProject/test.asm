.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data
	msg byte "he\nl\nl\no",0

.code
main proc
	mov eax, 3
	call alloc
main endp
end main