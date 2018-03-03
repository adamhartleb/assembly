.section .data

.section .bss

    .equ BUFFER_SIZE, 500
    .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.globl _start
_start:
    movl %esp, %ebp
    subl $8, %esp

file_fd_in:
    movl $5, %eax
    movl 8(%ebp), %ebx
    movl $0, %ecx
    movl $0666, %edx
    int $0x80

    movl %eax, -4(%ebp)

file_fd_out:
    movl $5, %eax
    movl 12(%ebp), %ebx
    movl $03101, %ecx
    movl $0666, %edx
    int $0x80

    movl %eax, -8(%ebp)

copy:
    movl $3, %eax
    movl -4(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl $500, %edx

    int $0x80

    cmpl $0, %eax
    je finished

    movl %eax, %edx
    movl $4, %eax
    movl -8(%ebp), %ebx
    movl $BUFFER_DATA, %ecx

    int $0x80

    jmp copy

finished:
    movl $6, %eax

    movl -4(%ebp), %ebx
    int $0x80

    movl -8(%ebp), %ebx
    int $0x80

    addl $8, %esp
    movl $1, %eax
    movl $0, %ebx
    int $0x80