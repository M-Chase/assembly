;编写一个累计加法，被加数是 0FH，加数是 01H，观察 Flags 的变化
;00100000->00100100
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,0FH
    mov bx,01H
    add ax,bx
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START