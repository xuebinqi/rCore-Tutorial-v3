/*********************************************************
 * 链接脚本主要用于如何把输入文件内的section放入输出文件中，
 * 并控制输出文件内各部分在程序地址空间内的布局
 ********************************************************/
OUTPUT_ARCH(riscv) /* 设置目标平台为 riscv */
ENTRY(_start)      /* 设置整个程序的入口点为entry.asm文件中定义的全局符号 _start */
BASE_ADDRESS = 0x80200000; /* 定义常量 BASE_ADDRESS = 0x80200000，即代码放置的起始地址 */

/* SECTIONS命令定义一些段（text、data、bss等段）链接分布 */
SECTIONS
{
    /* . 表示当前地址，也就是链接器会从它指向的位置，开始往下放置从输入的目标文件中收集来的段 */
    . = BASE_ADDRESS; /* 即从 0x80200000地址开始 */
    skernel = .;      
    /* 冒号前面表示最终生成的可执行文件的一个段的名字，花括号内按照放置顺序描述将所有输入目标文件的哪些段放在这个段中，
    每一行格式为 <ObjectFile>(SectionName)，表示目标文件 ObjectFile 的名为 SectionName 的段需要被放进去。
    我们也可以 使用通配符来书写 <ObjectFile> 和 <SectionName> 分别表示可能的输入目标文件和段名。
    因此，最终的合并结果是，在最终可执行文件中各个常见的段 .text, .rodata .data, .bss 从低地址到高地址按顺序放置，
    每个段里面都包括了所有输入目标文件的同名段， 且每个段都有两个全局符号给出了它的开始和结束地址
    （比如 .text 段的开始和结束地址分别是 stext 和 etext ） */
    stext = .; /* .text段的起始地址 */
    .text : { /* 栈段 */
        *(.text.entry) /* entry.asm 中的段 .text.entry */
        *(.text .text.*)
    }

    . = ALIGN(4K); /* ALIGN表示字节对齐，表示从该地址开始后面的存储进行4K字节对齐  */
    etext = .; /* .text段的结束地址，连接器会自动计算出当前地址 */
    srodata = .; /* .rodata段开始地址*/
    .rodata : { /* 只读数据段  */
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }

    . = ALIGN(4K);
    erodata = .;
    sdata = .;
    .data : { /* 数据段 */
        *(.data .data.*)
        *(.sdata .sdata.*)
    }

    . = ALIGN(4K);
    edata = .;
    .bss : { /* bbs段（未初始化数据段） */
        *(.bss.stack)
        sbss = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    . = ALIGN(4K);
    ebss = .;
    ekernel = .;

    /DISCARD/ : {
        *(.eh_frame)
    }
}