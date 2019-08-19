bits 64

start:
	; just fill some of the screen with red
	; not really trying to do anything nice here, just checking that it works
	mov rax, 0xFFFFFFFFFC000000
	.loop:
	mov dword [rax], 0xFFFF0000
	add rax, 4
	cmp rax, 0xFFFFFFFFFC0F0000
	jle .loop
	hlt
