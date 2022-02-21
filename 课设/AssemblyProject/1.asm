;�������򡢶�����ð������
.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data
	array sdword 49,38,65,97,76,13,27,49	;����
	arraySize = ($-array)/4					;C,size������Ϊ��ʶ��
	inputArray sdword 20 dup(?)				;�û���������
	inputArraySize dword ?					;�û���������Ĵ�С
	welcomeMsg1 byte "		                          __   ",0
	welcomeMsg2 byte "		  ______  ____  _______ _/  |_ ",0
	welcomeMsg3 byte "		 /  ___/ /  _ \ \_  __ \\   __\",0
	welcomeMsg4 byte "		 \___ \ (  <_> ) |  | \/ |  |  ",0
	welcomeMsg5 byte "		/____  > \____/  |__|    |__|  ",0
	welcomeMsg6 byte "		     \/                        ",0
	msg1 byte "Please input the length of the array you want to sort(less than 20):",0
	msg2 byte "Please input the array you want to sort:",0
	msg3 byte "Please choose your sort method:",0
	msg4 byte "1:quick sort",0
	msg5 byte "2:heap sort",0
	msg6 byte "3:bubble sort",0
	msg7 byte "The sorted array is:",0
	errorMsg byte "Your input is invalid",0
	devideMsg byte "*********************************************************************",0

.code
ExitProcess proto,
	dwExitCode:dword
inputArrayFunc proto
outputTips proto
quickSort proto,
	low1:sdword,
	high1:sdword
partition proto,
	low2:sdword,
	high2:sdword
heapSort proto
maxHeapify proto,
	start:dword,
	endding:dword
bubbleSort proto
outputArray proto

main proc
	;����-1����
	.while eax != 0FFFFFFFFH
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
		;�������鼰���С
		invoke inputArrayFunc
		invoke outputTips

		.if eax == 1
			;�±�Ϊ�����С��1
			mov eax, inputArraySize
			dec eax
			invoke quickSort, 0, eax
			invoke outputArray
			mov eax, 0
		.elseif eax == 2
			invoke heapSort
			invoke outputArray
			mov eax, 0
		.elseif eax == 3
			;invoke bubbleSort, addr array, lengthof array
			invoke bubbleSort
			invoke outputArray
			mov eax, 0
		.else
			mov eax, 0FFFFFFFFH
		.endif
		invoke WaitMsg
		invoke clrscr
	.endw
	invoke ExitProcess, 0
main endp


;inputArrayFunc()
;return eax:�Ƿ���ȷ�������飬1��ȷ��0����
inputArrayFunc proc uses ecx edx edi
	
	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg1				;���������鳤��
	invoke WriteString
	invoke ReadDec						;��ȡ���鳤��

	.if eax > 0 && eax <= 20			;�������>0��<=20���ֲ�������ֵ
		mov inputArraySize,eax
	.else								;���򱨴�
		mov edx,offset errorMsg
		invoke WriteString
		invoke Crlf
		mov eax, 0						;������������
		jmp quit1
	.endif

	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg2				;����������
	invoke WriteString
	invoke crlf
	mov ecx, 1
	mov edi, 0
	;ѭ����������
	.while inputArraySize >= ecx
		mov eax, ecx					;���"n:"
		invoke WriteDec
		mov eax, ":"
		invoke WriteChar

		invoke ReadInt					;��ȡһ����������
		mov inputArray[edi], eax		;�����ڴ�
		add edi, 4
		inc ecx
	.endw

	mov eax, 1							;��ȷ��������
quit1:
	ret
inputArrayFunc endp


;outputTips()
;return eax:ѡ���㷨����ţ�0�������
outputTips proc uses edx

	;��ѡ��ʹ�õ������㷨
	mov edx, offset devideMsg
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
	mov edx, offset msg6
	invoke WriteString
	invoke crlf
	;���������㷨�����
	invoke ReadDec
	.if eax != 1 && eax != 2 && eax != 3
		mov edx, offset errorMsg
		invoke WriteString
		invoke crlf
		mov eax, 0							;�������
	.endif

	ret
outputTips endp


;quickSort(dword low, dword high)
quickSort proc uses eax edi,
	low1:sdword,
	high1:sdword

	local pivot:sdword

	mov eax, low1
	.if eax < high1
		invoke partition, low1, high1
		mov pivot, eax
		
		dec eax
		invoke quickSort, low1, eax
		mov eax, pivot
		inc eax
		invoke quickSort, eax, high1
	.endif
	ret
quickSort endp


;partition(dword low, dword high)
;return eax low
partition proc uses ebx esi edi,
	low2:sdword,
	high2:sdword

	local pivot:sdword
	mov esi, low2
	mov edi, high2
	mov ebx, inputArray[esi * type inputArray]
	mov pivot, ebx

	.while esi < edi
		mov ebx, pivot
		.while esi < edi && inputArray[edi * type inputArray] >= ebx
			dec edi
		.endw
		mov ebx, inputArray[edi * type inputArray]
		mov inputArray[esi * type inputArray], ebx

		mov ebx, pivot
		.while esi < edi && inputArray[esi * type inputArray] <= ebx
			inc esi
		.endw
		mov ebx, inputArray[esi * type inputArray]
		mov inputArray[edi * type inputArray], ebx
	.endw

	mov ebx,pivot
	mov inputArray[esi * type inputArray], ebx
	mov eax, esi
	ret
partition endp


;heapSort()
heapSort proc uses eax edx esi
	local i:sdword

	mov eax, inputArraySize				;i=len/2-1
	mov edx, 2
	div dl								;ax/dl=al����ah
	mov ah, 0
	dec eax
	mov i, eax

	mov eax, inputArraySize				;eax=length-1
	dec eax
	.while i >= 0
		invoke maxHeapify, i, eax
		dec i
	.endw

	mov i, eax							;i=length-1
	.while i > 0
		mov esi, i
		mov eax, inputArray[0]				;eax=inputArray[0]
		xchg eax, inputArray[esi * type inputArray]
		mov inputArray[0], eax
		dec i
		invoke maxHeapify, 0, i
	.endw
	ret
heapSort endp


;maxHeapify(dword start, dword endding)
maxHeapify proc uses eax ebx ecx esi,
	start:dword,
	endding: dword

	local father:dword, son:dword

	mov eax, start							;father=start
	mov father, eax
	add eax, eax							;son=father*2+1
	inc eax
	mov son, eax

	mov ecx, endding
	.while son <= ecx
		mov ebx, son
		inc ebx
		mov esi, son
		mov eax, inputArray[esi * type inputArray]

		.if ebx <= endding && eax < inputArray[ebx * type inputArray]
			inc son
		.endif

		mov esi, son
		mov ebx, inputArray[esi * type inputArray]
		mov esi, father
		.if inputArray[esi * type inputArray] > ebx
			jmp quit2
		.else
			xchg inputArray[esi * type inputArray], ebx
			mov esi, son
			mov inputArray[esi * type inputArray], ebx

			xchg esi, father				;father=son
			add esi, esi					;son=father*2+1
			inc esi
			mov son, esi
		.endif
	.endw

quit2:
	ret
maxHeapify endp


;bubbleSort()
bubbleSort proc uses eax ecx esi,
	
	;ѭ������Ϊ�����С��1
	mov ecx,inputArraySize
	dec ecx
	;���ѭ��
	.while ecx > 0
		mov esi, 0
		push ecx
		
		;�ڲ�ѭ��
		.while ecx > 0
			mov eax, inputArray[esi]
			;�����������з������Ƚϱ�����һ���ڴ��������һ���ǼĴ���
			;���������ǼĴ�������Ĭ�����޷������Ƚ�
			.if eax > inputArray[esi+4]
				xchg eax, inputArray[esi+4]
				mov inputArray[esi], eax
			.endif
			add esi,4
			dec ecx
		.endw

		pop ecx
		dec ecx
	.endw
	ret
bubbleSort endp


;outputArray()
outputArray proc uses eax ecx esi,
	
	;������������
	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg7
	invoke WriteString
	
	;ѭ���������
	mov ecx, inputArraySize
	mov esi, 0
	.while ecx > 0
		mov eax, inputArray[esi]
		invoke WriteInt
		mov eax, " "
		invoke WriteChar
		add esi, 4
		dec ecx
	.endw
	invoke Crlf
	ret
outputArray endp


end main