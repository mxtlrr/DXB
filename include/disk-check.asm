;; Write to sector
;; Input:
;;	%1 -> number of sectors
;; 	%2 -> specific sector
;;	%3 -> data buffer
%macro write_sector 3
	mov ah, 0x03
	mov ch, 0x00	;; cylinder
	mov dh, 0x00	;; head
	mov al, %1		;; # of sectors
	mov cl, %2		;; specific sector to write
	
	;; setup data buffer
	push bx
	xor bx, bx
	mov es, bx
	pop bx
	mov bx, %3
	int 0x13

	;; if there are any errors we can check in a different label
	jc failed_op
%endmacro