.386
.model flat,c
.code
start:
	mov eax,71D2h
	mov ecx,5DF1h
	shrd ax,cx,2
	shld cx,ax,4
	mov ax,4c00h
	int 21h
end start