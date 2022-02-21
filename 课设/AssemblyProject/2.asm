.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data
	;字符串存储103位，从头开始存，首位用于保存符号，末位000AH用于输入结束
	string1 byte 103 dup(0)
	;数字串存储100位，从尾开始存
	num1 byte 100 dup(0)
	;数字的位数，不包含符号
	numSize1 byte ?
	;数字的符号
	sign1 byte ?

	string2 byte 103 dup(0)
	num2 byte 100 dup(0)
	numSize2 byte ?
	sign2 byte ?

	;结果数字，首位用于保存进位
	resultNum byte 101 dup(0)
	;结果的符号
	resultSign byte ?
	;结果的ascii码字符串
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

	local operation:byte, comperision:byte				;运算符+/-，绝对值大小0:相等/1:num_1大/2:num_2大

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

	;输入第一个数
	invoke input, offset string1, offset num1, offset numSize1, offset sign1

	;请输入运算符
	mov edx, offset msg2
	invoke WriteString
	invoke crlf
	;读入运算符到operation
	lea edx, operation
	mov ecx, 2
	invoke ReadString

	;输入第二个数
	invoke input, offset string2, offset num2, offset numSize2, offset sign2

	;比较绝对值的大小
	mov eax, 0
	invoke compare, offset num1, offset num2, offset numSize1, offset numSize2
	mov comperision, al

	;计算结果是
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
			.else								;num1 = num2输出0
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
			.else								;num1 = num2输出0
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
			.else								;num1 = num2输出0
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
			.else								;num1 = num2输出0
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

	;输出结果数字
	invoke output, offset resultNum, offset resultSign
	jmp exitMain

	;输出结果0
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

	local isSign:byte, sign:byte						;是否输入了符号(1有0无)，符号

	;请输入第一个数
	mov edx, offset msg1
	invoke WriteString
	invoke crlf

	;读入第一个数
	mov edx, pString1
	mov ecx, 101
	invoke ReadString
	
	;输入字符的长度存放在eax中，送入内存
	mov edi, pNumSize1
	;判断是否输入符号，以及正负，未输入符号默认为正
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

	;将ascii码转为十进制数字
	mov dl, 30H
	.while al > 0
		sub [esi], dl
		inc esi
		dec al
	.endw
	
	;确定字符串复制的起始位置及长度
	mov esi, pNumSize1
	mov cl, [esi]
	mov edi, pNum1
	add edi, 100
	sub edi, ecx
	mov esi, pString1
	.if isSign == 1
		inc esi
	.endif

	;将字符串传送至数字
	cld
	rep movsb

	ret
input endp


;compare(byte* pNum_1, byte* pNum_2, byte* pNumSize_1, byte* pNumSize_2)
;比较数字1的绝对值和数字2的绝对值
;return al, 1:num_1大,2:num_2大,0：相等
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
		;edx存储数字的位数
		mov edx, ebx
		mov eax, 0
		;bl = num1的首位数字，cl = num2的首位数字
		mov esi, pNum_1
		mov edi, pNum_2
		add esi, 100
		add edi, 100
		sub esi, ebx
		sub edi, ecx
		;依次比较各位数字
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

	;esi = num1的末位数字指针，edi = num2的末位数字指针，edx = 结果指针
	mov esi, pNum3
	mov edi, pNum4
	mov edx, pResult1
	add esi, 99
	add edi, 99
	add edx, 100

	mov ecx, 0									;计数
	add ecx, 0									;cf=0
	pushfd										;.while伪指令会影响标志位寄存器，所以用堆栈保存标志位寄存器
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

	;保存进位
	popfd
	mov eax, 0
	adc al, 0
	mov [edx], al

	ret
addTwoPositive endp


;subTwoPositive(byte* pNum5, byte* pNum6, byte* pNumSize5, byte* pNumSize6, byte* pResult2)
;pNum5为绝对值较大的数，pNum6为绝对值较小的数
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

	;esi = num1的末位数字指针，edi = num2的末位数字指针，edx = 结果指针
	mov esi, pNum5
	mov edi, pNum6
	mov edx, pResult2
	add esi, 99
	add edi, 99
	add edx, 100

	mov ecx, 0									;计数
	add ecx, 0									;cf=0
	pushfd										;.while伪指令会影响标志位寄存器，所以用堆栈保存标志位寄存器
	.while cl < size1							;num1始终大于等于num2，size1始终大于等于size2
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

	;大数减小数不产生借位
	ret
subTwoPositive endp


;output(byte* pResultNum, byte* pResultSign)
output proc uses eax ecx edx esi,
	pResultNum:ptr byte,
	pResultSign:ptr byte

	;输出结果符号
	mov esi, pResultSign
	mov al, [esi]
	invoke WriteChar

	mov esi, pResultNum
	mov ecx, lengthof resultNum
	;寻找第一个不为0的数字
	.while ecx > 0
		mov al, [esi]
		.if al != 0
			jmp realOutput
		.endif
		inc esi
		dec ecx
	.endw

	;找到后开始输出
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