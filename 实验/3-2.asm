;编写一个 32 位的乘法，被乘数是 0F0FH，乘数是 FF00H，观察 Flags 的变化。
;00100000->10010011 
DATA SEGMENT
    a dw 0F0FH
    b dw 0FF00H ;字母开头需要加0
DATA ENDS

STACKS SEGMENT
    ;db 16 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,DATA
    mov ds,ax
    ;mov ax,STACKS
    ;mov ss,ax
    ;mov sp,16

    mov ax,a
    mov bx,b
    mul bx
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START