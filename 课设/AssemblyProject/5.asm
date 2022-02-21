.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

MaxVertexNum = 100

;���������ӵĶ�����Ȩֵ
EdgeNode struct
	adjvex dword ?
	lowcost dword ?
	next dword ?					;ָ��EdgeNode
EdgeNode ends

EdgeNodeSize = sizeof EdgeNode		;EdgeNode�ṹ����ռ�ֽ��� = 12

;���嶥��
VertexNode struct
	vertex dword ?
	firstedge dword ?				;ָ��EdgeNode
VertexNode ends

VertexNodeLength = sizeof VertexNode

;ͼ�Ķ�������Ϊn,����Ϊe
ALGraph struct
	adjlist VertexNode MaxVertexNum dup(< 0,0 >)
	nNum dword ?					;������
	eNum dword ?					;����
ALGraph ends

;��¼���ʹ��Ķ���
Compare struct
	adjvex dword ?
	lowcost dword ?
Compare ends

compareSize = sizeof Compare

.data
	processHeap dword ?			;����Ѿ��
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

	;��ȡ����Ѿ��������ֵ��eax
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
;���Ҷ�����±�
;return eax, ������±꣬δ�ҵ�����-1
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
;�����ڽӱ�
create proc uses eax ebx ecx edx esi edi,
	G2:dword

	local iNum:dword, jNum:dword, kNum:dword, mNum:dword

	mov esi, G2
	;���붥����
	mov edx, offset msg1
	invoke WriteString
	invoke ReadDec
	mov (ALGraph ptr [esi]).nNum, eax

	;�������
	mov edx, offset msg2
	invoke WriteString
	invoke ReadDec
	mov (ALGraph ptr [esi]).eNum, eax

	mov ecx, (ALGraph ptr [esi]).nNum
	mov edi, 0
	.while edi < ecx
		;���������
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
		;�����߱�
		;��һ���ڵ�
		mov edx, offset msg4
		invoke WriteString
		invoke ReadInt
		mov iNum, eax
		;�ڶ����ڵ�
		mov edx, offset msg5
		invoke WriteString
		invoke ReadInt
		mov jNum, eax
		;Ȩ��
		mov edx, offset msg6
		invoke WriteString
		invoke ReadInt
		mov mNum, eax

		;�ҳ����Ȩ��
		mov eax, MAX
		.if mNum > eax
			mov eax, mNum
			mov MAX, eax
		.endif

		;�ҵ�����ڵ��λ���±�
		invoke localN, G2, iNum
		mov iNum, eax
		invoke localN, G2, jNum
		mov jNum, eax

		;���ٱ߽ṹ��洢�ռ�
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
		;ediΪ�߽ڵ��ָ��
		mov eax, jNum
		mov [edi], eax
		mov eax, mNum
		mov [edi + 4], eax
		mov ebx, iNum
		mov eax, (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge
		mov [edi + 8], eax
		mov (ALGraph ptr [esi]).adjlist[ebx * VertexNodeLength].firstedge, edi

		;���ٱ߽ṹ��洢�ռ�
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
		;ediΪ�߽ڵ��ָ��
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

	;���������Ȩ�ص������������ʾΪ��������û����ͨ
	inc MAX

	;��ʼ�����ж���
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
;�ҵ���С��Ȩ�صı�
;return eax, Ȩ����С�ıߣ�δ�ҵ�����-1
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

	;�붥��m2�����ıߵ�Ȩ�غͶ�������compare[]����
	mov edi, pPointer
	.while edi != 0
		mov eax, [edi]
		mov iNum, eax
		;����adjvexΪ��m2������������Ķ���
		mov eax, m2
		mov ebx, iNum
		mov compareList[ebx * compareSize].adjvex, eax
		mov eax, [edi + 4]
		mov compareList[ebx * compareSize].lowcost, eax
		;pNum = pNum->next
		mov edi, [edi + 8]
		mov pPointer, edi
	.endw

	;���ʹ��Ķ���ı�Ȩ��Ϊ0
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

			;���ϸ�����Ƚϣ�Ȩ��С�ı�����Ȩ�غ������ӵĶ���
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