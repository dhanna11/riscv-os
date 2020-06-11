kernel.elf: src/add.c src/asm/start.S src/lds/riscv64-virt.ld 
	riscv64-unknown-elf-gcc -g -O0 -ffreestanding -nostartfiles -nostdlib -nodefaultlibs -march=rv32i -mabi=ilp32 src/add.c src/asm/start.S -Wl,-T,src/lds/riscv64-virt.ld -o kernel.elf

add.elf: src/add.c
	riscv64-unknown-elf-gcc -g -O0 src/add.c -o add.elf

.PHONY: run-qemu
run-qemu: kernel.elf
	qemu-system-riscv32 --machine virt -m 128M -gdb tcp::1234 -bios default -nographic -S -kernel kernel.elf

