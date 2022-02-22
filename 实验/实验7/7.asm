;将71D2H存至AX中，5DF1H存至CX中，DST为AX，REG为CX
;实现双精度右移2次，交换DST与REG，然后左移4次，分别查看结果. 

DATA SEGMENT
    
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,71D2h
    mov bx,5DF1h
    mov cx,2
    
right:
    ror bx,1            ;循环右移
    rcr ax,1            ;带进位的循环右移
    loop right
    mov cx,2
    rol bx,cl           ;循环左移，将bx归位
    mov cx,4
left:
    rol ax,1            ;循环左移
    rcl bx,1            ;带进位的循环左移
    loop left
    mov cx,4
    ror ax,cl           ;循环右移，将ax归位

    MOV AH, 4CH
    INT 21H
CODES ENDS
END START