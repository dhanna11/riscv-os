#TODO: mcmodel=medany is required to link. 
# However, I don't think the memory space is large enough to require this?
# Double check linker script
kernel.elf: src/add2.c src/asm/start.S src/lds/riscv64-virt.ld 
	riscv64-unknown-elf-gcc -g -O0 -ffreestanding -nostartfiles -nostdlib -nodefaultlibs -mcmodel=medany src/add2.c src/asm/start.S -Wl,-T,src/lds/riscv64-virt.ld -o kernel.elf

add.elf: src/add.c
	riscv64-unknown-elf-gcc src/add.c -o add.elf

.PHONY: run-qemu debug-kernel
run-qemu: kernel.elf
	qemu-system-riscv64 --machine virt -m 128M -gdb tcp::1234 -bios default -nographic -S -kernel kernel.elf
debug-kernel: kernel.elf
	riscv64-unknown-elf-gdb -iex "set auto-load safe-path /" kernel.elf
