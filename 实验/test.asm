assume cs:codesg,ds:data

data segment
    dd 01234567h
data ends

codesg segment
start:
    mov ax,data
    mov ds,ax
    mov ax,ds:[0]
    mov dx,ds:[3]

    mov ax,4c00h
    int 21h
codesg ends
end start