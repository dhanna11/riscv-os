# boot.S
# jacked from Stephen Marz: http://osblog.stephenmarz.com/ch1.html
# riscv-abi: https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md
.option norvc # disable compressed instructions for now
.section .data # blank data for now
.section .init # place start.S at the begining of the ELF executable file being created

.global _start
// declare symbol _start as a function to help gdb terminate their backtrace
.type _start, @function
.cfi_startproc
_start:
  /* Clear the link register, so debuggers know to terminate their
   * backtrace. */
  .cfi_undefined ra

# The RISC-V ISA heavily uses linker relaxation:
# https://www.sifive.com/blog/all-aboard-part-3-linker-relaxation-in-riscv-toolchain
# TLDR: attempts to use smaller branch instructions (compressed jal, jal) 
# instead of an auipc_ jalr pair for shorter jumps.
# We must disable it for this instruction only. 
.option push
.option norelax
  la gp, __global_pointer$ # load address of symbol _global_pointer to register 
# gp (register x3) as required by the risc-v abi
.option pop

/* Setup the stack pointer. */
la sp, __stack_top$
/* Setup the frame pointer */
add s0, sp, zero
/* Clear argc and argv */
li a0, 0
li a1, 0

// TODO: zero the BSS
// TODO: relocate the data section
// TODO: call __libc_init_array
// TODO: register __libc_fini_array with atexit
j main
.cfi_endproc
.end 

