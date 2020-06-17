# stolen and mutated from Stephen Marz: http://osblog.stephenmarz.com/ch1.html
# References: riscv-abi: https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md
.option norvc # disable compressed instructions
.section .data # blank data for now
.section .init # place start.S at the begining of the ELF executable file being created

.global _start
// declare symbol _start as a function to help gdb terminate its backtrace
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
# We must disable it for loading the global_pointer$. 
.option push
.option norelax
  la gp, __global_pointer$ # load global pointer as required by risc-v abi 
.option pop

  /* Setup the stack pointer for c environment. */
  la sp, __stack_top$
  /* Setup the frame pointer for c enviornment */
  add s0, sp, zero
  /* Clear argc and argv */
  li a0, 0
  li a1, 0

  // Zero the bss
  la t0, __bss_start
  la t1, _end
  bgeu t0, t1, 2f
1:
  sw zero, t0
  addi t0, t0, 4
  bltu t0, t1, 1b
2:


// TODO: initialize static variables
// INVESTIGATE: reason for relocating the data section 
// INVESTIGATE: calling __libc_init_array
// INVESTIGATE: registering __libc_fini_array with atexit

j main
.cfi_endproc
.end 

