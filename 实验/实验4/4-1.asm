;编写一个 16 位的除法，被除数是 100H，除数是 100H，观察 Flags 的变化
;AX的变化过程为：0100H->0001H
;flags变化 00100000->00100000
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,100H
    mov dx,0
    mov bx,100H
    div bx          ;商在AX,余数在DX

    MOV AH, 4CH
    INT 21H
CODES ENDS
END START