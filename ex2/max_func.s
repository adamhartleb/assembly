.section .data

data_items:
  .long 18,3,7,24,1,58,3,10
data_end:

.section .text
.globl _start
_start:
  call maximum

  movl $1, %eax
  int $0x80

.type maximum, @function
maximum:
  pushl %ebp
  movl %esp, %ebp
  movl $0, %edi
  movl data_items(,%edi,4), %ebx

max_loop:
  incl %edi
  movl data_items(,%edi,4), %eax

  cmpl data_end, %eax
  je end_max

  cmpl %ebx, %eax
  jl max_loop

  movl %eax, %ebx
  jmp max_loop

end_max:
  movl %esp, %ebp
  popl %ebp
  ret
  
  
