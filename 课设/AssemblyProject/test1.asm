INCLUDE Irvine32.inc

    ListNode STRUCT
        NodeData DWORD ?
        NextPtr DWORD ?
    ListNode ENDS
    TotalNodeCount = 15
    NULL = 0
    Counter = 0

.data

    putc     macro   ptr

     push    eax

     mov     al, ptr
     call    writechar

     pop     eax
     endm

     ;to use:             
     ;putc        'a'



    LinkedList LABEL PTR ListNode

REPEAT TotalNodeCount
    Counter = Counter + 1
    ListNode <Counter, ($ + Counter * SIZEOF ListNode)>
    ;struct variables Counter, and ($+Counter*SIZEOF ListNode) being declared 
    ;
    ENDM

    ListNode <0,0> ; tail node

.code

main PROC
    mov esi,OFFSET LinkedList
    ; Display the integers in the NodeData fields.
    NextNode:
    ; Check for the tail node.

    putc    'a'; ->first node, then third node

    mov eax,(ListNode PTR [esi]).NextPtr
    cmp eax,NULL
    je quit
    ; Display the node data.

    putc   'b' ;->fourth node 

    mov eax,(ListNode PTR [esi]).NodeData
    call WriteDec
    call Crlf
    ; Get pointer to next node.

    putc   'c' ;->first node 
    putc   'd' ;->second node 
    mov esi,(ListNode PTR [esi]).NextPtr
    ;references a struct using [esi] 
    jmp NextNode
    quit:


    exit
main ENDP
END main