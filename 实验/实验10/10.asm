;斐波纳契数列：1，1，2，3，5，8，13。通常可以使用递归函数实现，现用汇编实现该过程。
DATA SEGMENT
    a dw 0001h,0001h,0000h        ;f(n-1),f(n-2),结果
DATA ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES, DS:DATA, SS:STACKS
START:
    MOV AX, DATA
    MOV DS, AX
    mov si,0
    mov bx,a[si]        ;f(n-1)
    mov dx,a[si+2]      ;f(n-2)

    mov ax,10
    cmp ax,1
    jna circle1
    cmp ax,2
    je circle2

;输入>2:
    mov cl,al           ;循环次数为（输入-2）次
    sub cl,2
loo:  
    mov ax,0            ;当前f(n)
    add ax,bx           ;f(n)=f(n-1)+f(n-2)
    add ax,dx
    mov dx,bx           ;f(n-2)=f(n-1)
    mov bx,ax           ;f(n-1)=f(n)
    mov a[si],bx        ;更换DATA里的前两个值
    mov a[si+2],dx
    loop loo
    mov a[si+4],ax      ;算出结果
    jmp quit
    
circle1: 
    mov a[si+4],ax      ;输入<=1,结果=输入
    jmp quit
circle2: 
    mov ax,1            ;输入=2,结果=1
    mov a[si+4],ax
    jmp q
quit:  
    MOV AH, 4CH
    INT 21H
CODES ENDS
END START