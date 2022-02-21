;实现KMP算法，输入两个字符串（可以直接保存在内存中），实现快速匹配
DATA SEGMENT
    s db 'ababcabcacbab'
    t db 'abcac'            ;要求模式串不超过10个字符
    n db 10 dup(0)
DATA ENDS

STACKS SEGMENT
    db 16 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    mov ax,DATA
    mov ds,ax
    mov es,ax
    mov ax,STACKS
    mov ss,ax
    mov sp,16
    jmp main

;求next数组，存放在数据段的数据标号n处
next:mov si,1
    mov di,0
    mov cx,offset n - offset t
    dec cx
    mov ah,00h
l1: cmp di,0
    je i1
    dec si
    dec di
    mov al,t[si]
    mov bl,t[di]
    inc si
    inc di
    cmp al,bl
    jne e1
i1: inc si
    inc di
    mov ax,di
    mov n[si],al
    jmp l2
e1: mov al,n[di]
    mov di,ax
    inc cx
l2: loop l1
    ret

;kmp算法主函数
main:call next
    mov si,1
    mov di,1
    mov ah,00h
    ;循环判断是否超出长度
l3: mov cx,offset t - offset s
    cmp si,cx
    ja o1
    mov cx,offset n - offset t
    cmp di,cx
    ja o1

    cmp di,0
    je i2
    dec si
    dec di
    mov al,s[si]
    mov bl,t[di]
    inc si
    inc di
    cmp al,bl
    jne e2
i2: inc si
    inc di
    jmp l4
e2: mov al,n[di]
    mov di,ax
l4: loop l3

o1: mov cx,offset n - offset t
    cmp di,cx
    ja o2
    mov dl,23H          ;未找到匹配字符串，显示#
    jmp o3
o2: sub si,cx           ;找到匹配字符串，显示匹配位置
    add si,30H
    mov dx,si
o3: mov ah,2
    int 21H
    
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START