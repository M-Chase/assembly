;实现非压缩BCD码的加减法，用非压缩BCD码实现（21+71），（12+49），（65+82）
;（46-33），（74-58），（43-54）的十进制加减法。
DATA SEGMENT
    a dw 0201H,0102H,0605H,0406H,0704H,0403H
    b dw 0701H,0409H,0802H,0303H,0508H,0504H
    h dw 6 dup (0)      ;存放结果高位
    l dw 6 dup (0)      ;存放结果低位
DATA ENDS

STACKS SEGMENT
    db 16 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,DATA
    mov ds,ax
    mov ax,STACKS
    mov ss,ax
    mov sp,16           ;SS：堆栈段寄存器

;加法
    mov di,0
    mov cx,3
ad:  
    mov ah,00100000b
    sahf                ;清空标志位寄存器
    mov ax,0[di]
    mov bx,12[di]
    add ah,bh
    add al,bl
    aaa                 ;非压缩BCD码结果转换十进制

    cmp ah,09H
    jna protect         ;如果ah不大于09H则跳过
    sub ah,0AH
    mov bx,0001H
    mov 24[di],bx       ;如果ah大于09H则高位保存进位

protect1:
    mov 36[di],ax       ;将结果保存到数据段
    inc di
    inc di
    loop ad

;减法
    mov cx,3
su:  
    mov ah,00100000b
    sahf                ;清空标志位寄存器
    mov ax,0[di]
    mov bx,12[di]
    sub ah,bh
    sub al,bl
    aas

    cmp ah,09H
    jna protect2        ;如果ah不大于09H则跳过
    mov ax,0[di]        ;如果ah大于09H则反着减
    mov bx,12[di]
    sub bh,ah
    sub bl,al
    mov ax,bx
    aas                 ;非压缩BCD码结果转换
    mov bx,1000H
    mov 24[di],bx

protect2:
    mov 36[di],ax
    inc di
    inc di
    loop su
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START