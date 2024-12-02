global main
extern printf

section .data
fmt db "%u "
arr dq 5, 13, 1, 42, 3 
len equ 5
counter dq 0

section .text
main:
    call bubble_sort
    mov qword [counter], 0
    call print_array
    ret

bubble_sort:
    mov rax, 0
    
    inner_loop:
        mov rcx, [arr+rax*8]    ; current element
        mov rdx, [arr+rax*8+8]  ; next element

        cmp rcx, rdx
        jl increment            ; left < right, ignore the swap

        call swap

    increment:
        inc rax
        mov r8, -1
        add r8, len
        sub r8, qword [counter]
        cmp rax, r8
        jl inner_loop           ; r8 < len-1-counter

    inc qword [counter]
    mov rax, [counter]
    mov r8, -1
    add r8, len
    cmp rax, r8
    jne bubble_sort

    ret

swap:
    mov [arr+rax*8], rdx
    mov [arr+rax*8+8], rcx

    ret

print_array:
    ; get array element
    mov rax, [counter]
    mov rsi, [arr+rax*8]

    push rbp
    mov rax, 0      ; it prevents SEGFAULT, but idk why it should be zero
    mov rdi, fmt    ; formatter
    call printf
    pop rbp

    inc qword [counter]
    mov rax, [counter]
    cmp rax, len
    jne print_array

    ret