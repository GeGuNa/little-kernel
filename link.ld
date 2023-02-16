OUTPUT_FORMAT(binary)
ENTRY(_kernel22)

SECTIONS
{
   . = 0x9000;
   .text : { *(.text) }
   .bss : { *(.bss) }
   .data : { *(.data) }
   .rodata : { *(.rodata) }
}
