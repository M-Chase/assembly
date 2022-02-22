;编写一个累计加法，从1加到5，将结果保存至AX中。 
assume cs:addtion
addtion segment

start:
    mov ax,1
    mov bx,1
    mov cx,4        ;计数寄存器
loo:  
    inc bx
    add ax,bx
    loop loo
    mov AG,4cH
    int 21h
    

addtion ends
end start