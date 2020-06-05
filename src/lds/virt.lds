/* 
   virt.lds
   Jacked from Stephen Marz (pavehawk2007):https://github.com/pavehawk2007/osblog/blob/master/risc_v/src/lds/virt.lds 
   My first linker script!
*/

/* Linker scripts are a list of newline seperated commands to our program linker */
OUTPUT_ARCH("riscv") 

ENTRY(_start) /* Defined in boot.S */

MEMORY 
{
  ram (wxa) : ORIGIN = 0x80000000, LENGTH = 128M
}


