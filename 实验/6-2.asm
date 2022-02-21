;将 8F1DH 存至 AX 中，然后带 CF 位左移 5位，
;并右移7位，观察Flags的变化，并给出结果
;8F1DH->E3A8H->A3C7H
;00100000->10100001->00100000
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,8F1DH
    mov cl,5
    rcl ax,cl
    mov cl,7
    rcr ax,cl
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START