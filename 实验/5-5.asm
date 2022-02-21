;被加数是FFFFFFFFH加数是01H，观察Flags的变化
;00100000->00101111->00101111->00100000
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,0FFFFh   ;低位
    mov dx,0FFFFh   ;高位
    mov cx,0        ;进位
    mov bx,01h
    add ax,bx
    adc dx,0
    adc cx,0

    MOV AH, 4CH
    INT 21H
CODES ENDS
END START