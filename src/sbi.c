struct sbiret {
  long error;
  long value;
};

struct sbiret sbi_get_spec_version(void) {
  long function_id = 0;
  long extension_id = 0x10;
  struct ret = sbicall(function_id, extension_id);
  return ret; 
}
// Copy-pasta from arch/riscv/kernel/sbi.c
struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
			unsigned long arg1, unsigned long arg2,
			unsigned long arg3, unsigned long arg4,
			unsigned long arg5)
{
	struct sbiret ret;

	register uintptr_t a0 asm ("a0") = (uintptr_t)(arg0);
	register uintptr_t a1 asm ("a1") = (uintptr_t)(arg1);
	register uintptr_t a2 asm ("a2") = (uintptr_t)(arg2);
	register uintptr_t a3 asm ("a3") = (uintptr_t)(arg3);
	register uintptr_t a4 asm ("a4") = (uintptr_t)(arg4);
	register uintptr_t a5 asm ("a5") = (uintptr_t)(arg5);
	register uintptr_t a6 asm ("a6") = (uintptr_t)(fid);
	register uintptr_t a7 asm ("a7") = (uintptr_t)(ext);
  /* @NOTES:
     This extended asm code performs an ecall.
     The compiler is mostly ignorant about what's going on inside of the text literal 
     of an inline asm call. It must be told about the side-effects of the instruction 
     on registers/C values and memory.
     "r" contraint declares that the operand must be a register.
     "+" modifier means that the operand is read and written by the instruction. 
     "memory" is a special clobber argument that indicates a memory read or write occurs to a location
     outside the operand list.
  */
	asm volatile ("ecall"
		      : "+r" (a0), "+r" (a1) 
		      : "r" (a2), "r" (a3), "r" (a4), "r" (a5), "r" (a6), "r" (a7)
		      : "memory");
	ret.error = a0;
	ret.value = a1;

	return ret;
}

