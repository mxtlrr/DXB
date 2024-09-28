%macro IRQ 2
irq_stub_%1:
	push byte 0
	push byte %2
	jmp irq_stub
%endmacro

IRQ 0,  32
IRQ 1,  33
IRQ 2,  34
IRQ 3,  35
IRQ 4,  36
IRQ 5,  37
IRQ 6,  38
IRQ 7,  39
IRQ 8,  40
IRQ 9,  41
IRQ 10, 42
IRQ 11, 43
IRQ 12, 44
IRQ 13, 45
IRQ 14, 46
IRQ 15, 47

extern irq_handler
irq_stub:
	pusha
	mov ax, ds
	push eax
	mov ax, 10h
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	push esp

	call irq_handler
	pop ebx
	pop ebx
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	popa
	add esp, 8
	sti
	iret

global irq_stub_table
irq_stub_table:
%assign j 0
%rep 15
	dd irq_stub_%+j
%assign j j+1
%endrep