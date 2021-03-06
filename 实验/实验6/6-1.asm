;编写一个移位运算，将8F1DH存至AX，然后用指令右移1位然后左移1位
;显示结果并观察 Flags 的变化
;AX变化:8F1DH->478EH->8F1CH
;flags变化: 00100000->10100011->10110000
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,8F1Dh
    shr ax,1        ;逻辑右移
    shl ax,1        ;逻辑左移
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START