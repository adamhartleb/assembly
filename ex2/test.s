.section .data

.section .text
.global _start
_start:
  pushl $3
  pushl $2
  call power
  addl $8, %esp

  pushl %eax

  pushl $2
  pushl $4
  call power
  addl $8, %esp

  popl %ebx
  addl %eax, %ebx

  movl $1, %eax
  int $0x80

.type power, @function
power:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp

  movl 8(%ebp), %ebx
  movl 12(%ebp), %ecx
  
  movl %ecx, -4(%ebp)

power_start_loop:
  cmpl $1, %ebx
  je end_power

  movl -4(%ebp), %eax
  imul %ecx, %eax
  movl %eax, -4(%ebp)

  decl %ebx
  jmp power_start_loop

end_power:
  movl -4(%ebp), %eax
  movl %ebp, %esp
  popl %ebp
  ret
