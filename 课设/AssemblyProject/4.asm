.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

Node struct
	num sdword ?				;����	4byte	offset:0
	next dword ?				;��̽ڵ��ָ��	4byte	offset:4
Node ends

structSize = sizeof Node		;Node�ṹ����ռ�ֽ��� = 8

.data
	processHeap dword ?			;����Ѿ��
	pointer dword ?				;�ڴ��ָ��
	welcomeMsg1 byte ".__  .__        __              .___ .__  .__          __   ",0
	welcomeMsg2 byte "|  | |__| ____ |  | __ ____   __| _/ |  | |__| _______/  |_ ",0
	welcomeMsg3 byte "|  | |  |/    \|  |/ // __ \ / __ |  |  | |  |/  ___/\   __\",0
	welcomeMsg4 byte "|  |_|  |   |  \    <\  ___// /_/ |  |  |_|  |\___ \  |  |  ",0
	welcomeMsg5 byte "|____/__|___|  /__|_ \\___  >____ |  |____/__/____  > |__|  ",0
	welcomeMsg6 byte "             \/     \/    \/     \/               \/        ",0
	devideMsg byte "*************************************************************",0
	msg0 byte "A linked list is being created.",0
	msg1 byte "Please input the action:",0
	msg2 byte "1.Insert a node",0
	msg3 byte "2.Delete a node",0
	msg4 byte "3.Search a node",0
	msg5 byte "4.Update a node",0
	msg6 byte "The linked list is:",0
	msg7 byte "Please input the new number:",0
	msg8 byte "Please input the position you want to insert:",0
	msg9 byte "Please input the index you want to delete:",0
	msg10 byte "Please input the index you want to search:",0
	msg11 byte "Please input the index you want to update:",0
	msg12 byte "The number found is:",0
	msgFail byte "Allocation failed!",0

.code
ExitProcess proto,
	dwExitCode:dword
outputWelcome proto
outputTips proto
output proto,
	pList1:dword
init proto
insert proto,
	pList2:dword
delete proto,
	pList3:dword
search proto,
	pList4:dword
update proto,
	pList5:dword

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
	mov edx, offset msg0
	invoke WriteString
	invoke crlf

	;��ʼ�������һ���ڵ㣬�����������׵�ַ
	invoke init
	jc quit										;����ʧ��
	mov pointer, eax

	;��ʾ��������
	invoke output, eax							;���ٳɹ�

loopStart:
	.while eax != 0FFFFFFFFH
		;��ȡִ�е�����
		invoke outputTips
		invoke ReadDec
		
		.if eax == 1
			invoke insert, pointer
			jc quit								;����ʧ��
			mov pointer, eax
			invoke output, pointer
		.elseif eax == 2
			invoke delete, pointer
			jc quit								;ȫ��ɾ��
			mov pointer, eax
			invoke output, pointer
		.elseif eax == 3
			invoke search, pointer
		.elseif eax == 4
			invoke update, pointer
			invoke output, pointer
		.else
			jmp quit
		.endif
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


;outputTips()
outputTips proc uses edx

	;����ִ�е�����
		mov edx, offset devideMsg
		invoke WriteString
		invoke crlf
		mov edx, offset msg1
		invoke WriteString
		invoke crlf
		mov edx, offset msg2
		invoke WriteString
		invoke crlf
		mov edx, offset msg3
		invoke WriteString
		invoke crlf
		mov edx, offset msg4
		invoke WriteString
		invoke crlf
		mov edx, offset msg5
		invoke WriteString
		invoke crlf

	ret
outputTips endp


;output(dword* pList1)
output proc uses eax edx esi,
	pList1:dword

	mov edx, offset msg6
	invoke WriteString
	invoke crlf

	mov esi, pList1
	;add esi, 4
	mov edx, 0
	.while [esi + 4] != edx
		mov eax, [esi]
		invoke WriteInt
		mov al, ' '
		invoke WriteChar
		mov esi, [esi + 4]
	.endw
	mov eax, [esi]
	invoke WriteInt

	invoke crlf
	ret
output endp


;init()
;return eax, ���������ٿռ��ָ�룬 cf = 0 ���ٳɹ��� cf = 1 ����ʧ��
init proc uses edx edi,
	
	;���ٿռ䲢����ַ��ջ
	mov eax, 0
	clc
	invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, structSize
	.if eax == null
		mov edx, offset msgFail
		invoke WriteString
		stc
		jmp exitInit
	.else
		push eax
	.endif

	;����32λ�з�������
	mov edx, offset msg7
	invoke WriteString
	invoke ReadInt
	pop edi
	mov [edi], eax

	mov eax, edi
	clc
exitInit:
	ret
init endp


;insert(dword* pList2)
;return eax, �����׵�ַ�� cf = 0 ���ٳɹ��� cf = 1 ����ʧ��
insert proc uses ebx ecx edx esi edi,
	pList2:dword

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg8
	invoke WriteString

	invoke ReadDec
	mov esi, pList2
	mov ecx, 0
	.while ecx < eax
		mov edx, [esi + 4]
		.if edx == 0
			jmp insertNode
		.endif
		inc ecx
		mov ebx, esi
		mov esi, [esi + 4]
	.endw

insertNode:
	.if ecx < eax							;β��
		mov eax, 0
		clc
		invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, structSize
		.if eax == null
			mov edx, offset msgFail
			invoke WriteString
			stc
			jmp exitInsert
		.else
			push eax
		.endif

		;����32λ�з�������
		mov edx, offset msg7
		invoke WriteString
		invoke ReadInt
		pop edi
		mov [edi], eax
		;ָ��ָ���½ڵ�ĵ�ַ
		mov [esi + 4], edi
		mov eax, pList2

	.else									;ecx = eax
		.if eax == 0						;ͷ��
			mov eax, 0
			clc
			invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, structSize
			.if eax == null
				mov edx, offset msgFail
				invoke WriteString
				stc
				jmp exitInsert
			.else
				push eax
			.endif

			;����32λ�з�������
			mov edx, offset msg7
			invoke WriteString
			invoke ReadInt
			pop edi
			mov [edi], eax
			;�½ڵ�ָ��ָ���׵�ַ
			mov [edi + 4], esi
			;�����µ�ͷָ��
			mov eax, edi

		.else								;�м��
			mov eax, 0
			clc
			invoke HeapAlloc, processHeap, HEAP_ZERO_MEMORY, structSize
			.if eax == null
				mov edx, offset msgFail
				invoke WriteString
				stc
				jmp exitInsert
			.else
				push eax
			.endif

			;����32λ�з�������
			mov edx, offset msg7
			invoke WriteString
			invoke ReadInt
			pop edi
			mov [edi], eax

			;����ָ��
			mov esi, ebx
			mov edx, [esi + 4]
			mov [edi + 4], edx
			mov [esi + 4], edi
			mov eax, pList2

		.endif
	.endif

exitInsert:
	ret
insert endp


;delete(dword* pList3)
;return eax, �����׵�ַ�� cf = 0 ɾ���ɹ��� cf = 1 ȫ��ɾ��
delete proc uses ebx ecx edx esi edi,
	pList3:dword

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg9
	invoke WriteString

	invoke ReadDec
	mov esi, pList3
	mov ebx, esi
	mov ecx, 0
	.while ecx < eax
		mov edx, [esi + 4]
		.if edx == 0
			jmp deleteNode
		.endif
		inc ecx
		mov ebx, esi
		mov esi, [esi + 4]
	.endw

deleteNode:
	.if ecx < eax						;βɾ
		.if ebx == esi
			stc
			jmp quitDelete
		.endif
		clc
		mov eax, 0
		mov [ebx + 4], eax
		mov eax, pList3
	.else
		.if eax == 0					;ͷɾ
			clc
			mov eax, [esi + 4]
			.if eax == 0
				stc						;cf = 1 ȫ��ɾ��
				jmp quitDelete
			.endif
		.else							;�м�ɾ
			clc
			mov eax, [esi + 4]
			mov [ebx + 4], eax
			mov eax, pList3
		.endif
	.endif

quitDelete:
	ret
delete endp


;search(dword* pList4)
search proc uses eax ebx ecx edx esi,
	pList4:dword

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg10
	invoke WriteString
	invoke crlf

	invoke ReadDec
	mov esi, pList4
	mov ecx, 0
	.while ecx < eax
		mov edx, [esi + 4]
		.if edx == 0
			jmp searchNode
		.endif
		inc ecx
		mov ebx, esi
		mov esi, [esi + 4]
	.endw

searchNode:
	mov edx, offset msg12
	invoke WriteString
	mov eax, [esi]
	invoke WriteInt
	invoke crlf

quitSearch:
	ret
search endp


;update(dword* pList5)
update proc uses eax ebx ecx edx esi,
	pList5:dword

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg11
	invoke WriteString

	invoke ReadDec
	mov esi, pList5
	mov ecx, 0
	.while ecx < eax
		mov edx, [esi + 4]
		.if edx == 0
			jmp updateNode
		.endif
		inc ecx
		mov ebx, esi
		mov esi, [esi + 4]
	.endw

updateNode:
	mov edx, offset msg7
	invoke WriteString
	invoke ReadInt
	mov [esi], eax

exitUpdate:
	ret
update endp


end main