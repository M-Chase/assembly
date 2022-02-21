.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

MaxVertexNum = 100

;定义相连接的顶点与权值
EdgeNode struct
	adjvex dword ?
	lowcost dword ?
	next dword ?					;指向EdgeNode
EdgeNode ends

EdgeNodeSize = sizeof EdgeNode		;EdgeNode结构体所占字节数 = 12

;定义顶点
VertexNode struct
	vertex dword ?
	firstedge dword ?				;指向EdgeNode
VertexNode ends

VertexNodeLength = sizeof VertexNode

;图的顶点数量为n,边数为e
ALGraph struct
	adjlist VertexNode MaxVertexNum dup(< 0,0 >)
	nNum dword ?					;顶点数
	eNum dword ?					;边数
ALGraph ends

;记录访问过的顶点
Compare struct
	adjvex dword ?
	lowcost dword ?
Compare ends

compareSize = sizeof Compare

.data
	processHeap dword ?			;程序堆句柄
	MAX dword 0
	G ALGraph <>
	compareList Compare MaxVertexNum dup(< 0,0 >)

	welcomeMsg1 byte "	             .__         ",0
	welcomeMsg2 byte "	_____________|__| _____  ",0
	welcomeMsg3 byte "	\____ \_  __ \  |/     \ ",0
	welcomeMsg4 byte "	|  |_> >  | \/  |  Y Y  \",0
	welcomeMsg5 byte "	|   __/|__|  |__|__|_|  /",0
	welcomeMsg6 byte "	|__|                  \/ ",0
	devideMsg byte "************************************************",0
	msg1 byte "Please input vertex number:",0
	msg2 byte "Please input edge number:",0
	msg3 byte "Please input vertex value:",0
	msg4 byte "Please input the first vertex of the edge:",0
	msg5 byte "Please input the second vertex of the edge:",0
	msg6 byte "Please input the edge weight:",0
	msg7 byte "The minimum spanning tree is:",0
	msg8 byte "The adjacent list is:",0
	msgFail byte "Allocation failed!",0

.code
ExitProcess proto,
	dwExitCode:dword
outputWelcome proto
localN proto,
	G1:dword,
	m1:dword
create proto,
	G2:dword
findMin proto,
	G3:dword
prim proto,
	G4:dword,
	m2:dword

main proc

	;获取程序堆句柄，返回值在eax
	invoke GetProcessHeap
	.if eax == null
		call WriteWindowsMsg
		jmp quit
	.else
		mov processHeap, eax
	.endif

	invoke outputWelcome

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf

	invoke create, offset G

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg7
	invoke WriteString
	invoke crlf

	invoke prim, offset G, 0

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg8
	invoke WriteString
	invoke crlf

	mov esi, offset G
	mov ebx, 0
	mov edi, 0
	mov ecx, (ALGraph ptr [esi]).nNum
	.while edi < ecx
		
		mov ebx, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].firstedge
		mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex
		
		invoke WriteInt
		mov eax, '-'
		invoke WriteChar
		mov eax, '>'
		invoke WriteChar

		.while ebx != 0
			push edi
			mov edi, [ebx]
			mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex
			invoke WriteInt
			mov eax, '-'
			invoke WriteChar
			mov eax, '>'
			invoke WriteChar
			pop edi
			mov ebx, [ebx + 8]
		.endw

		invoke crlf
		inc edi
	.endw

quit:
	invoke ExitProcess, 0
main endp


outputWelcome proc uses ebx

	mov edx, offset welcomeMsg1
	invoke WriteString
	invoke crlf
	mov edx, offset welcomeMsg2
	invoke WriteString
	invoke crlf
	mov edx, offset welcomeMsg3
	invoke WriteString
	invoke crlf
	mov edx, offset welcomeMsg4
	invoke WriteString
	invoke crlf
	mov edx, offset welcomeMsg5
	invoke WriteString
	invoke crlf
	mov edx, offset welcomeMsg6
	invoke WriteString
	invoke crlf

	ret
outputWelcome endp


;localN(dword* G1, dword m1)
;查找顶点的下标
;return eax, 顶点的下标，未找到返回-1
localN proc uses ebx ecx esi edi,
	G1:dword,
	m1:dword

	mov esi, G1
	mov ecx, (ALGraph ptr [esi]).nNum
	mov edi, 0
	.while edi < ecx
		mov ebx, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex
		.if ebx == m1
			mov eax, edi
			jmp exitLocalN
		.endif
		inc edi
	.endw

	mov eax, -1
exitLocalN:
	ret
localN endp


;create(dword* G2)
;创建邻接表
create proc uses eax ebx ecx edx esi edi,
	G2:dword

	local iNum:dword, jNum:dword, kNum:dword, mNum:dword

	mov esi, G2
	;读入顶点数
	mov edx, offset msg1
	invoke WriteString
	invoke ReadDec
	mov (ALGraph ptr [esi]).nNum, eax

	;读入边数
	mov edx, offset msg2
	invoke WriteString
	invoke ReadDec
	mov (ALGraph ptr [esi]).eNum, eax

	mov ecx, (ALGraph ptr [esi]).nNum
	mov edi, 0
	.while edi < ecx
		;建立顶点表
		mov edx, offset msg3
		invoke WriteString
		invoke ReadInt
		mov (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex, eax
		mov eax, 0
		mov (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].firstedge, 0
		inc edi
	.endw

	mov ecx, (ALGraph ptr [esi]).eNum
	mov edi, 0
	mov kNum, edi
	.while edi < ecx
		push ecx
		push edi
		;建立边表
		;第一个节点
		mov edx, offset msg4
		invoke WriteString
		invoke ReadInt
		mov iNum, eax
		;第二个节点
		mov edx, offset msg5
		invoke WriteString
		invoke ReadInt
		mov jNum, eax
		;权重
		mov edx, offset msg6
		invoke WriteString
		invoke ReadInt
		mov mNum, eax

		;找出最大权重
		mov eax, MAX
		.if mNum > eax
			mov eax, mNum
			mov MAX, eax
		.endif

		;找到输入节点的位置下标
		invoke localN, G2, iNum
		mov iNum, eax
		invoke localN, G2, jNum
		mov jNum, eax

		;开辟边结构体存储空间
		mov eax, 0
		clc
		invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, EdgeNodeSize
		.if eax == null
			mov edx, offset msgFail
			invoke WriteString
			stc
			jmp exitCreate
		.endif

		mov edi, eax
		;edi为边节点的指针
		mov eax, jNum
		mov [edi], eax
		mov eax, mNum
		mov [edi + 4], eax
		mov ebx, iNum
		mov eax, (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge
		mov [edi + 8], eax
		mov (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge, edi

		;开辟边结构体存储空间
		mov eax, 0
		clc
		invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, EdgeNodeSize
		.if eax == null
			mov edx, offset msgFail
			invoke WriteString
			stc
			jmp exitCreate
		.endif
		
		mov edi, eax
		;edi为边节点的指针
		mov eax, iNum
		mov [edi], eax
		mov eax, mNum
		mov [edi + 4], eax
		mov ebx, jNum
		mov eax, (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge
		mov [edi + 8], eax
		mov (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge, edi

		pop edi
		inc edi
		pop ecx
	.endw

	;制作比最大权重的数还大的数表示为两个顶点没有连通
	inc MAX

	;初始化所有顶点
	mov ecx, (ALGraph ptr [esi]).nNum
	mov edi, 0
	.while edi < ecx
		mov eax, MAX
		mov compareList[edi * VertexNodeLength].lowcost, eax
		inc edi
	.endw

ExitCreate:
	ret
create endp


;FindMin(dword* G3)
;找到最小的权重的边
;return eax, 权重最小的边，未找到返回-1
findMin proc uses ebx ecx edx esi edi,
	G3:dword

	local result:dword, minNum:dword

	mov esi, G3
	mov eax, MAX
	mov minNum, eax
	mov eax, -1
	mov result, eax

	mov edi, 0
	mov ecx, (ALGraph ptr [esi]).nNum
	.while edi < ecx
		mov edx, compareList[edi * compareSize].lowcost
		.if minNum > edx && edx != 0
			mov minNum, edx
			mov eax, edi
		.endif
		inc edi
	.endw

	ret
findMin endp


;prim(dword* G4, dword m2)
prim proc uses eax ebx ecx edx esi edi,
	G4:dword,
	m2:dword

	local iNum:dword, jNum:dword, kNum:dword, nNum:dword, t1:dword, t2:dword, pPointer:dword

	mov esi, G4
	mov eax, 0
	invoke localN, G4, m2
	mov kNum, eax
	mov edi, kNum
	mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].firstedge
	mov pPointer, eax

	;与顶点m2相连的边的权重和顶点输入compare[]数组
	mov edi, pPointer
	.while edi != 0
		mov eax, [edi]
		mov iNum, eax
		;这里adjvex为与m2这个顶点相连的顶点
		mov eax, m2
		mov ebx, iNum
		mov compareList[ebx * compareSize].adjvex, eax
		mov eax, [edi + 4]
		mov compareList[ebx * compareSize].lowcost, eax
		;pNum = pNum->next
		mov edi, [edi + 8]
		mov pPointer, edi
	.endw

	;访问过的顶点的边权重为0
	mov edi, kNum
	mov eax, 0
	mov compareList[edi * compareSize].lowcost, eax

	mov iNum, 1
	mov edi, iNum
	mov ecx, (ALGraph ptr [esi]).nNum
	.while edi < ecx
		push ecx
		push edi
		invoke findMin, G4
		mov kNum, eax
		mov edi, kNum
		mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex
		mov t1, eax
		mov eax, compareList[edi * compareSize].adjvex
		mov t2, eax

		mov eax, t2
		invoke WriteInt
		mov eax, '-'
		invoke WriteChar
		mov eax, '>'
		invoke WriteChar
		mov eax, t1
		invoke WriteInt
		invoke crlf

		mov edi, kNum
		mov eax, 0
		mov compareList[edi * compareSize].lowcost, eax
		mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].firstedge
		mov pPointer, eax
		
		mov edi, pPointer
		.while edi != 0
			mov eax, [edi]
			mov nNum, eax
			
			mov ebx, nNum
			mov eax, compareList[ebx * compareSize].lowcost
			mov edx, [edi + 4]

			;与上个顶点比较，权重小的边输入权重和相连接的顶点
			.if eax > edx
				push edi
				mov edi, kNum
				mov eax, (ALGraph ptr [esi]).adjlist[edi * VertexNodeLength].vertex
				mov compareList[ebx * compareSize].adjvex, eax
				pop edi

				mov eax, [edi + 4]
				mov compareList[ebx * compareSize].lowcost, eax
			.endif
			mov edi, [edi + 8]
			mov pPointer, edi
		.endw

		pop edi
		inc edi
		pop ecx
	.endw

	ret
prim endp


end main