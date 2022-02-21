;编写一个累计加法，从1加到5，将结果保存至AX中。 
assume cs:addtion
addtion segment

start:
    mov ax,1
    mov bx,1
    mov cx,4
s:  inc bx
    add ax,bx
    loop s
    mov ax,4c00h
    int 21h

addtion ends
end start