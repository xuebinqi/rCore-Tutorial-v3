/* _start, boot_stack, boot_statck_top，叫做lable，用于代码或者数据的位置表示 */
    .section .text.entry # _start被放入到.text.entry段，位于.text的最开始
    .globl _start
_start:
    la sp, boot_stack_top /* 设置栈顶指针 */
    call rust_main

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 * 16 # 栈大小是4K
    .globl boot_stack_top
boot_stack_top: # 栈结尾