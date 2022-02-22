;编写一个 32 位的乘法，被乘数是 0F0FH，乘数是 FF00H，观察 Flags 的变化。
; AX的变化过程为：0F0FH->0000h
; BX的变化过程为：0000H->0000H
; CX的变化过程为：FF00H->0EFFH
; DX的变化过程为：0000H->F100H

;flags变化 00100000->10010011 
DATA SEGMENT
    a dw 0f0fh          ;a为第一个数的低位
    b dw 0000h          ;b为第一个数的高位
    c dw 0ff00h         ;c为第二个数的低位
    d dw 0000h          ;d为第二个数的高位
    result dw 4 dup (0) ;10 dup（0）重复定义了4个字元素，初始值为0
DATA ENDS

STACKS SEGMENT
    ;db 16 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,DATA
    mov ds,ax

    mov ax,a            
    mov dx,c
    mul dx
    mov [result],ax
    mov [result+2],dx     

    mov ax,b
    mov dx,c
    mul dx
    add [result+2],ax
    adc [result+4],dx      

    mov ax,a
    mov dx,d
    mul dx
    add [result+2],ax
    adc [result+4],dx
    adc [result+6],0       

    mov ax,b
    mov dx,d
    mul dx
    add [result+4],ax
    adc [result+6],dx

    mov ax,[result+6]
    mov bx,[result+4]
    mov cx,[result+2]
    mov dx,[result]

    MOV AH, 4CH
    INT 21H
CODES ENDS
END START