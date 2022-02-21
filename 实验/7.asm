;将71D2H存至AX中，5DF1H存至CX中，DST为AX，REG为CX
;实现双精度右移2次，交换DST与REG，然后左移4次，分别查看结果. 
.586
DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,71D2h
    mov cx,5DF1h
    shrd ax,cx,2
    shld cx,ax,4
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START