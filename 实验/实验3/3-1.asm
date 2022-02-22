;编写一个 16 位的乘法，被乘数是 100H，乘数是 100H，观察 Flags 的变化，
; AX的变化过程为：0100H->0000H
; DX的变化过程为：0000H->1000H
; flags变化 00100000->10100011
DATA SEGMENT

DATA ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov bx,0100h
    mov ax,0100h
    mul bx         ;高位在DX,低位在AX   flag值cf为1
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START