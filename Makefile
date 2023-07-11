all: ramfs

linux:
	$(MAKE) -C $@

linux/samples/bpf: linux
	$(MAKE) -C $@

ramfs: linux/samples/bpf
	@echo "  CALL  usr/gen_initramfs.sh"
	@cd linux;                   \
		usr/gen_initramfs.sh     \
			-o ../ramfs          \
			../busybox/_install/ \
			../cpio

run: ramfs
	@echo "  RUN   qemu-system-x86_64"
	@qemu-system-x86_64                        \
		-enable-kvm                            \
		-nographic                             \
		-kernel linux/arch/x86_64/boot/bzImage \
		-initrd ramfs                          \
		-append "console=ttyS0"

debug: ramfs
	@echo "  RUN   qemu-system-x86_64"
	@qemu-system-x86_64                        \
		-enable-kvm                            \
		-nographic                             \
		-kernel linux/arch/x86_64/boot/bzImage \
		-initrd ramfs                          \
		-append "console=ttyS0"                \
		-gdb tcp::2222                         \
		-S

.PHONY: linux linux/samples/bpf
