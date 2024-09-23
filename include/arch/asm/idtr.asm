extern exception_handler
%macro isr_err_stub 1
isr_stub_%+%1:
	;; The error code has already been pushed to the stack
	;; when the interrupt is raised, so all we need to do is
	;; push the ISR number
	push byte %1
	jmp isr_stub
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
	push byte 0		;; Empty error code
	push byte %1	;; Push the ISR number to the stack
	jmp isr_stub
%endmacro

isr_stub:
	pusha
	mov ax, ds
	push eax
	mov ax, 10h
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	push esp

	call exception_handler
	pop ebx
	
	pop ebx
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	popa

	add esp, 8
	iret

isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31

global isr_stub_table
isr_stub_table:
%assign i 0 
%rep    32 
  dd isr_stub_%+i
%assign i i+1 
%endrep