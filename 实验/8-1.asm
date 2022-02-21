;实现压缩BCD码的加减法，用压缩BCD码实现（21+71），（12+49），（65+82）
;（46-33），（74-58），（43-54）的十进制加减法。
DATA SEGMENT
    a db 21H,12H,65H,46H,74H,43H
    b db 71H,49H,82H,33H,58H,54H
    h db 6 dup (0)      ;存放结果高位
    l db 6 dup (0)      ;存放结果低位
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
    mov sp,16

;加法
    mov di,0
    mov cx,3
x:  mov ah,00100000b
    sahf                ;清空标志位寄存器
    mov al,0[di]
    mov bl,6[di]
    add al,bl
    daa
    lahf                ;标志位寄存器送入ah
    and ah,00000001b

    mov 12[di],ah       ;将结果保存到数据段
    mov 18[di],al
    inc di
    loop x

;减法
    mov cx,3
y:  mov ah,00100000b
    sahf                ;清空标志位寄存器
    mov al,0[di]
    mov bl,6[di]
    sub al,bl
    das                 

    jnb n               ;如果cf=0则跳过
    mov al,0[di]        ;如果cf=1则bx-ax，再把bx放入ax
    mov bl,6[di]
    sub bl,al
    mov al,bl
    das                 
    mov ah,10h
    mov 12[di],ah

n:  mov 18[di],al
    inc di
    loop y
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START