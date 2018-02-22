.section .data

data_items:  
 .long 3,4,18,243,8,12,5,1
data_end:

.section .text

.globl _start
_start:
  movl $0, %edi
  movl data_items(,%edi,4), %eax
  movl %eax, %ebx
  leal data_end, %ecx

start_loop:
  leal data_items(,%edi,4), %eax
  cmpl %eax, %ecx
  je exit_loop
  incl %edi
  movl data_items(,%edi,4), %eax
  cmpl %ebx, %eax
  jge start_loop
  movl %eax, %ebx
  jmp start_loop
 
exit_loop:
  movl $1, %eax
  int $0x80 
