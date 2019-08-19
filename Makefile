kernel: main.asm
	nasm -f elf64 main.asm -o out/main.o
	ld -m elf_x86_64 -T link.ld -o out/main.bin out/main.o

initrd: kernel
	mkdir -p out/initrd_img/sys/
	cp out/main.bin out/initrd_img/sys/core
	find out/initrd_img/ | cpio -H newc -o | gzip > out/INITRD

mkboot:
	$(MAKE) -C bootboot/x86_64-bios/ mkboot

image: initrd mkboot
	dd if=/dev/zero of=out/outer.img bs=512 count=93750
	parted out/outer.img -s -a minimal mklabel gpt
	parted out/outer.img -s -a minimal mkpart FAT32 2048s 93716s
	parted out/outer.img -s -a minimal toggle 1 boot
	dd if=/dev/zero of=out/inner.img bs=512 count=91669
	mformat -i out/inner.img -h 32 -t 32 -n 64 -c 1
	mmd -i out/inner.img ::BOOTBOOT
	mcopy -i out/inner.img out/INITRD ::BOOTBOOT/INITRD
	mcopy -i out/inner.img bootboot/bootboot.bin ::BOOTBOOT/LOADER
	dd if=out/inner.img of=out/outer.img bs=512 count=91669 seek=2048 conv=notrunc
	./bootboot/x86_64-bios/mkboot out/outer.img

run: image
	qemu-system-x86_64 -hda out/outer.img
