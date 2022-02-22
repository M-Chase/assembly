;编写一个 32 位的除法，被除数是 0F0FH，除数是 00FFH，观察 Flags 的变化。 
;AX的变化过程为：0F0FH->000FH
;flags变化 00100000->00100000
DATA SEGMENT
    a dd 0f000f0fh
	b dw 00ffh
	c dw 0
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
	mov ax, DATA
	mov ds, ax
	mov ax, a
	mov bx, b
	div ax,bx				;指针形式
	mov ds:[6], ax			;余数保存在DX,结果保存在AX
	
	mov AH, 4cH
	int 21H
CODES ENDS
END START
