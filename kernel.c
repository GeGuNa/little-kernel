#include "include/ioports.h"
#include "include/monitor.h"

//int a = 0;

//int prt(){
	
//char* b = (char*)0xB8000;	

//char *a = str;

	
//return 	0;
//}

void _kernel22() {
	
monitor_write("We've successfully entered the to protected mode \n");	
monitor_write("Code from 32bit/protected mode \n");	
monitor_write("now  we can execute 63kb code from hd ;) ");

	

		
//for (;;);
//asm("hlt");
}



void kernel() {
	
//monitor_write("test");	


	char *str = "Hello, world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222world22222222222", *ch;
	unsigned short *vidmem = (unsigned short*) 0xb8000;
	unsigned i;
	
	for (ch = str, i = 0; *ch; ch++, i++)
		vidmem[i] = (unsigned char) *ch | 0x0700;
		
	for (;;);

}
