.section .data

.equ OPEN, 5

.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.globl _start
_start:
  movl %esp, %ebp
  subl $8, %esp

open_fd_in:
  movl $OPEN, %eax
  movl 8(%ebp), %ebx
  movl $0, %ecx
  movl $0666, %edx
  int $0x80

store_fd_in:
  movl %eax, -4(%ebp)

open_fd_out:
  movl $OPEN, %eax
  movl 12(%ebp), %ebx
  movl $03101, %ecx
  movl $0666, %edx
  int $0x80

store_fd_out:
  movl %eax, -8(%ebp)

read_loop_begin:
  movl $3, %eax
  movl -4(%ebp), %ebx
  movl $BUFFER_DATA, %ecx
  movl $BUFFER_SIZE, %edx
  int $0x80

  cmpl $0, %eax
  jle end_loop

continue_read_loop:
  pushl $BUFFER_DATA
  pushl %eax
  call convert_to_upper
  popl %eax
  addl $4, %esp

  movl %eax, %edx
  movl $4, %eax
  movl -8(%ebp), %ebx
  movl $BUFFER_DATA, %ecx
  int $0x80

  jmp read_loop_begin

end_loop:
  movl $6, %eax
  movl -8(%ebp), %ebx
  int $0x80

  movl $6, %eax
  movl -4(%ebp), %ebx
  int $0x80

  movl $1, %eax
  movl $0, %ebx
  int $0x80

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPERCASE_A, 'A'
.equ UPPER_CONVERSION, 'A' - 'a'

convert_to_upper:
  pushl %ebp
  movl %esp, %ebp

  movl 12(%ebp), %eax
  movl 8(%ebp), %ebx
  movl $0, %edi

  cmpl $0, %ebx
  jle end_convert_loop

convert_loop:
  movb (%eax,%edi,1), %cl

  cmpb $LOWERCASE_A, %cl
  jl next_byte
  
  cmpb $LOWERCASE_Z, %cl
  jg next_byte

  addb $UPPER_CONVERSION, %cl
  movb %cl, (%eax,%edi,1)

next_byte:
  incl %edi
  
  cmpl %ebx, %edi
  jne convert_loop

end_convert_loop:
  movl %ebp, %esp
  popl %ebp
  ret
