;被加数是0FFFH，加数是 01H，观察 Flags 的变化
; AX的变化过程为：0FFFH->1000H
; flags变化 00100000->00100110
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,0FFFh
    mov bx,01h
    add ax,bx
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START