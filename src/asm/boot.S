# boot.S
# jacked from Stephen Marz: http://osblog.stephenmarz.com/ch1.html
# riscv-abi: https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md
.option norvc # disable compressed instructions for now
.section .data # blank data for now

.global _start
_start:
  # Any hardware threads (hart) that are not bootstrapping need to wait for an
  # interprocessor interrupt
  csrr t0, mhartid # constrol status register read mhartid register
  bnez t0, 3f # f for forward jump...
  # Set Supervisor address translation and protection register () to zero to disable paging for now
  csrw satp, zero

# The RISC-V ISA heavily uses linker relaxation:
# https://www.sifive.com/blog/all-aboard-part-3-linker-relaxation-in-riscv-toolchain
# TLDR: attempts to use smaller branch instructions (compressed jal, jal) 
# instead of an auipc_ jalr pair for shorter jumps.
# We must disable it for this instruction only. 
.option push
.option norelax
  la gp, _global_pointer # load address of symbol _global_pointer to register 
# gp (register x3) as required by the risc-v abi

.option pop

3:
  wfi
  j 3b # ... and b from backward jump!
  

