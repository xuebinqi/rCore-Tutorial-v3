OUTPUT_ARCH(riscv)
/* 将 _start 所在的 .text.entry 放在整个程序的开头，
也就是说批处理系统只要在加载之后跳转到 0x80400000 
就已经进入了用户库的入口点，并会在初始化之后跳转到应用程序主逻辑 */
ENTRY(_start)

/* 程序的其实地址位0x80400000，bin目录下的三个英应用程序都会被加载到这个地址 */
BASE_ADDRESS = 0x80400000; 

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *(.text.entry)
        *(.text .text.*)
    }
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
    }
    .bss : {
        start_bss = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        end_bss = .;
    }
    /DISCARD/ : {
        *(.eh_frame)
        *(.debug*)
    }
}