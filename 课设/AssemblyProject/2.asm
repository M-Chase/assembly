.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data
	;�ַ����洢103λ����ͷ��ʼ�棬��λ���ڱ�����ţ�ĩλ000AH�����������
	string1 byte 103 dup(0)
	;���ִ��洢100λ����β��ʼ��
	num1 byte 100 dup(0)
	;���ֵ�λ��������������
	numSize1 byte ?
	;���ֵķ���
	sign1 byte ?

	string2 byte 103 dup(0)
	num2 byte 100 dup(0)
	numSize2 byte ?
	sign2 byte ?

	;������֣���λ���ڱ����λ
	resultNum byte 101 dup(0)
	;����ķ���
	resultSign byte ?
	;�����ascii���ַ���
	resultString byte 101 dup(0)
	welcomeMsg1 byte "	                 /\          ",0
	welcomeMsg2 byte "	     __         / /          ",0
	welcomeMsg3 byte "	  __|  |___    / /    ______ ",0
	welcomeMsg4 byte "	 /__    __/   / /    /_____/ ",0
	welcomeMsg5 byte "	    |__|     / /             ",0
	welcomeMsg6 byte "	             \/              ",0
	devideMsg byte "***************************************************",0
	msg1 byte "Please input number(less than 100 bits):",0
	msg2 byte "Please input the operation you want to do(+/-):",0
	msg3 byte "The result is:",0

.code
ExitProcess proto,
	dwExitCode:dword
input proto,
	pString1:ptr byte,
	pNum1:ptr byte,
	pNumSize1:ptr byte,
	pSign1:ptr byte
compare proto,
	pNum_1:ptr byte,
	pNum_2:ptr byte,
	pNumSize_1:ptr byte,
	pNumSize_2:ptr byte
addTwoPositive proto,
	pNum3:ptr byte,
	pNum4:ptr byte,
	pNumSize3:ptr byte,
	pNumSize4:ptr byte,
	pResult:ptr byte
output proto,
	pResultNum:ptr byte,
	pResultSign:ptr byte
subTwoPositive proto,
	pNum5:ptr byte,
	pNum6:ptr byte,
	pNumSize5:ptr byte,
	pNumSize6:ptr byte,
	pResult2:ptr byte

main proc

	local operation:byte, comperision:byte				;�����+/-������ֵ��С0:���/1:num_1��/2:num_2��

loopStart:
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
	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf

	;�����һ����
	invoke input, offset string1, offset num1, offset numSize1, offset sign1

	;�����������
	mov edx, offset msg2
	invoke WriteString
	invoke crlf
	;�����������operation
	lea edx, operation
	mov ecx, 2
	invoke ReadString

	;����ڶ�����
	invoke input, offset string2, offset num2, offset numSize2, offset sign2

	;�ȽϾ���ֵ�Ĵ�С
	mov eax, 0
	invoke compare, offset num1, offset num2, offset numSize1, offset numSize2
	mov comperision, al

	;��������
	mov edx, offset devideMsg
	invoke WriteString
	invoke crlf
	mov edx, offset msg3
	invoke WriteString
	invoke crlf

	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0
	mov al, sign1
	mov bl, sign2
	mov cl, operation
	.if cl == '+'
		.if al == '+' && bl == '+'
			;(+)+(+) 1
			invoke addTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
			mov resultSign, '+'
		.elseif al == '-' && bl == '-'
			;(-)+(-) 1
			invoke addTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
			mov resultSign, '-'
		.elseif al =='+' && bl == '-'
			;(+)+(-) 2
			.if comperision == 1				;num1 > num2
				invoke subTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
				mov resultSign, '+'
			.elseif comperision == 2			;num1 < num2
				invoke subTwoPositive, offset num2, offset num1, offset numSize2, offset numSize1, offset resultNum
				mov resultSign, '-'
			.else								;num1 = num2���0
				jmp outputZero
			.endif
		.else									;al == '-' && bl == '+'
			;(-)+(+) 2
			.if comperision == 1				;num1 > num2
				invoke subTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
				mov resultSign, '-'
			.elseif comperision == 2			;num1 < num2
				invoke subTwoPositive, offset num2, offset num1, offset numSize2, offset numSize1, offset resultNum
				mov resultSign, '+'
			.else								;num1 = num2���0
				jmp outputZero
			.endif
		.endif
	.else										;cl == '-'
		.if al == '+' && bl == '+'
			;(+)-(+) 2
			.if comperision == 1				;num1 > num2
				invoke subTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
				mov resultSign, '+'
			.elseif comperision == 2			;num1 < num2
				invoke subTwoPositive, offset num2, offset num1, offset numSize2, offset numSize1, offset resultNum
				mov resultSign, '-'
			.else								;num1 = num2���0
				jmp outputZero
			.endif
		.elseif al == '-' && bl == '-'
			;(-)-(-) 2
			.if comperision == 1				;num1 > num2
				invoke subTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
				mov resultSign, '-'
			.elseif comperision == 2			;num1 < num2
				invoke subTwoPositive, offset num2, offset num1, offset numSize2, offset numSize1, offset resultNum
				mov resultSign, '+'
			.else								;num1 = num2���0
				jmp outputZero
			.endif
		.elseif al =='+' && bl == '-'
			;(+)-(-) 1
			invoke addTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
			mov resultSign, '+'
		.else									;al == '-' && bl == '+'
			;(-)-(+) 1
			invoke addTwoPositive, offset num1, offset num2, offset numSize1, offset numSize2, offset resultNum
			mov resultSign, '-'
		.endif
	.endif

	;����������
	invoke output, offset resultNum, offset resultSign
	jmp exitMain

	;������0
outputZero:
	mov eax, 0
	invoke WriteDec

exitMain:
	invoke crlf
	invoke WaitMsg
	invoke clrscr
	jmp loopStart
main endp


;input(byte* pString1, byte* pNum1, byte* pNumSize1, byte* pSign1)
input proc uses eax ebx ecx edx esi edi,
	pString1:ptr byte,
	pNum1:ptr byte,
	pNumSize1:ptr byte,
	pSign1:ptr byte

	local isSign:byte, sign:byte						;�Ƿ������˷���(1��0��)������

	;�������һ����
	mov edx, offset msg1
	invoke WriteString
	invoke crlf

	;�����һ����
	mov edx, pString1
	mov ecx, 101
	invoke ReadString
	
	;�����ַ��ĳ��ȴ����eax�У������ڴ�
	mov edi, pNumSize1
	;�ж��Ƿ�������ţ��Լ�������δ�������Ĭ��Ϊ��
	mov edx, 0
	mov esi, pString1
	mov dl, [esi]
	mov ebx, pSign1
	.if dl == '+'
		mov isSign, 1
		dec eax
		mov [edi], al
		mov [ebx], dl
		inc esi
	.elseif dl == '-'
		mov isSign, 1
		dec eax
		mov [edi], al
		mov [ebx], dl
		inc esi
	.else
		mov isSign, 0
		mov [edi],al
		mov dl, 2BH
		mov [ebx], dl
	.endif

	;��ascii��תΪʮ��������
	mov dl, 30H
	.while al > 0
		sub [esi], dl
		inc esi
		dec al
	.endw
	
	;ȷ���ַ������Ƶ���ʼλ�ü�����
	mov esi, pNumSize1
	mov cl, [esi]
	mov edi, pNum1
	add edi, 100
	sub edi, ecx
	mov esi, pString1
	.if isSign == 1
		inc esi
	.endif

	;���ַ�������������
	cld
	rep movsb

	ret
input endp


;compare(byte* pNum_1, byte* pNum_2, byte* pNumSize_1, byte* pNumSize_2)
;�Ƚ�����1�ľ���ֵ������2�ľ���ֵ
;return al, 1:num_1��,2:num_2��,0�����
compare proc uses ebx ecx edx esi edi,
	pNum_1:ptr byte,
	pNum_2:ptr byte,
	pNumSize_1:ptr byte,
	pNumSize_2:ptr byte

	;bl = numSize1, cl = numSize2
	mov ebx, 0
	mov ecx, 0
	mov esi, pNumSize_1
	mov edi, pNumSize_2
	mov bl, [esi]
	mov cl, [edi]

	.if ebx > ecx								;num1>num2
		mov al, 1
		jmp quit
	.elseif ebx < ecx							;num1<num2
		mov al, 2
		jmp quit
	.else
		;edx�洢���ֵ�λ��
		mov edx, ebx
		mov eax, 0
		;bl = num1����λ���֣�cl = num2����λ����
		mov esi, pNum_1
		mov edi, pNum_2
		add esi, 100
		add edi, 100
		sub esi, ebx
		sub edi, ecx
		;���αȽϸ�λ����
		.while eax < edx
			mov bl, [esi]
			mov cl, [edi]
			.if bl > cl								;num1>num2
				mov al, 1
				jmp quit
			.elseif bl < cl							;num1<num2
				mov al, 2
				jmp quit
			.endif
			inc esi
			inc edi
			inc eax
		.endw
		;num1=num2
		mov al, 0
	.endif

quit:
	ret
compare endp


;addTwoPositive(byte* pNum3, byte* pNum4, byte* pNumSize3, byte* pNumSize4, byte* pResult1)
addTwoPositive proc uses eax ebx ecx edx esi edi,
	pNum3:ptr byte,
	pNum4:ptr byte,
	pNumSize3:ptr byte,
	pNumSize4:ptr byte,
	pResult1:ptr byte

	;size1 = numSize1, size2 = numSize2
	local size1:byte, size2:byte

	;al = numSize1, bl = numSize2
	mov eax, 0
	mov ebx, 0
	mov esi, pNumSize3
	mov edi, pNumSize4
	mov al, [esi]
	mov bl, [edi]
	mov size1, al
	mov size2, bl

	;esi = num1��ĩλ����ָ�룬edi = num2��ĩλ����ָ�룬edx = ���ָ��
	mov esi, pNum3
	mov edi, pNum4
	mov edx, pResult1
	add esi, 99
	add edi, 99
	add edx, 100

	mov ecx, 0									;����
	add ecx, 0									;cf=0
	pushfd										;.whileαָ���Ӱ���־λ�Ĵ����������ö�ջ�����־λ�Ĵ���
	.while cl < size1 || cl < size2
		popfd
		mov al, [esi]
		mov bl, [edi]
		adc al, bl
		aaa
		mov [edx], al
		dec esi
		dec edi
		dec edx
		inc cl
		pushfd
	.endw

	;�����λ
	popfd
	mov eax, 0
	adc al, 0
	mov [edx], al

	ret
addTwoPositive endp


;subTwoPositive(byte* pNum5, byte* pNum6, byte* pNumSize5, byte* pNumSize6, byte* pResult2)
;pNum5Ϊ����ֵ�ϴ������pNum6Ϊ����ֵ��С����
subTwoPositive proc uses eax ebx ecx edx esi edi,
	pNum5:ptr byte,
	pNum6:ptr byte,
	pNumSize5:ptr byte,
	pNumSize6:ptr byte,
	pResult2:ptr byte

	;size1 = numSize1, size2 = numSize2
	local size1:byte, size2:byte

	;al = numSize1, bl = numSize2
	mov eax, 0
	mov ebx, 0
	mov esi, pNumSize5
	mov edi, pNumSize6
	mov al, [esi]
	mov bl, [edi]
	mov size1, al
	mov size2, bl

	;esi = num1��ĩλ����ָ�룬edi = num2��ĩλ����ָ�룬edx = ���ָ��
	mov esi, pNum5
	mov edi, pNum6
	mov edx, pResult2
	add esi, 99
	add edi, 99
	add edx, 100

	mov ecx, 0									;����
	add ecx, 0									;cf=0
	pushfd										;.whileαָ���Ӱ���־λ�Ĵ����������ö�ջ�����־λ�Ĵ���
	.while cl < size1							;num1ʼ�մ��ڵ���num2��size1ʼ�մ��ڵ���size2
		popfd
		mov al, [esi]
		mov bl, [edi]
		sbb al, bl
		aas
		mov [edx], al
		dec esi
		dec edi
		dec edx
		inc cl
		pushfd
	.endw

	;������С����������λ
	ret
subTwoPositive endp


;output(byte* pResultNum, byte* pResultSign)
output proc uses eax ecx edx esi,
	pResultNum:ptr byte,
	pResultSign:ptr byte

	;����������
	mov esi, pResultSign
	mov al, [esi]
	invoke WriteChar

	mov esi, pResultNum
	mov ecx, lengthof resultNum
	;Ѱ�ҵ�һ����Ϊ0������
	.while ecx > 0
		mov al, [esi]
		.if al != 0
			jmp realOutput
		.endif
		inc esi
		dec ecx
	.endw

	;�ҵ���ʼ���
realOutput:
	.while ecx > 0
		mov al, [esi]
		add al, 30H
		invoke WriteChar
		inc esi
		dec ecx
	.endw

	ret
output endp


end main