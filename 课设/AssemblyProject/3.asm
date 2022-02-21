.386
.model flat,stdcall
.stack 4096
include Irvine32.inc

.data
	year word ?
	welcomeMsg1 byte "                            ",0
	welcomeMsg2 byte " ___.__. ____ _____ _______ ",0
	welcomeMsg3 byte "<   |  |/ __ \\__  \\_  __ \",0
	welcomeMsg4 byte " \___  \  ___/ / __ \|  | \/",0
	welcomeMsg5 byte " / ____|\___  >____  /__|   ",0
	welcomeMsg6 byte " \/         \/     \/       ",0
	devideMsg byte "********************************",0
	msg1 byte "Please input a year(1~65535):",0
	msg2 byte "The year you input is a leap year.",0
	msg3 byte "The year you input is a common year.",0
	msgError byte "Your input is invalid",0

.code

main proc

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

	mov edx, offset msg1
	invoke WriteString

	mov eax, 0
	invoke ReadInt
	.if eax < 1 || eax > 65535
		jmp exitMain
	.endif
	mov year, ax

	;能被400整除是闰年
	mov edx, 0
	mov ax, year
	mov ebx, 400
	div bx
	;余数在dx
	.if dx == 0
		mov edx, offset msg2
		invoke WriteString
		jmp loopEnd
	.endif

	;能被100整除不是闰年
	mov edx, 0
	mov ax, year
	mov ebx, 100
	div bx
	.if dx == 0
		mov edx, offset msg3
		invoke WriteString
		jmp loopEnd
	.endif

	;能被4整除是闰年，否则不是闰年
	mov edx, 0
	mov ax, year
	mov ebx, 4
	div bx
	.if dx == 0
		mov edx, offset msg2
		invoke WriteString
	.else
		mov edx, offset msg3
		invoke WriteString
	.endif

loopEnd:
	invoke crlf
	invoke WaitMsg
	invoke clrscr
	jmp loopStart

exitMain:
	mov edx, offset msgError
	invoke WriteString
	invoke crlf
	invoke ExitProcess, 0
main endp

end main