/*
 *  ChlorineOS - A work-in-progress operating system working to be
 *               UNIX-like...
 *
 *  Copyright (C) 2022 Nexuss (https://github.com/Dashbloxx)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/*
 *  The files `ioports.c` & `ioports.h` are used to interact with hardware using the CPU...
 */

#include <stdint.h>

#include "../include/ioports.h"

void outb(unsigned int port, unsigned char data)
{
    asm volatile("outb %b0, %w1"
                 :
                 : "a"(data), "Nd"(port));
}

uint8_t inb(unsigned int port)
{
    uint8_t data;
    asm volatile("inb %w1, %b0"
                 : "=a"(data)
                 : "Nd"(port));
    return data;
}

void outw(unsigned int port, unsigned short int data)
{
    asm volatile("outw %w0, %w1"
                 :
                 : "a"(data), "Nd"(port));
}

uint16_t inw(unsigned int port)
{
    uint16_t data;
    asm volatile("inw %w1, %w0"
                 : "=a"(data)
                 : "Nd"(port));
    return data;
}

void outl(unsigned int port, unsigned int data)
{
    asm volatile("outl %0, %w1"
                 :
                 : "a"(data), "Nd"(port));
}

uint32_t inl(unsigned int port)
{
    uint32_t data;
    asm volatile("inl %w1, %0"
                 : "=a"(data)
                 : "Nd"(port));
    return data;
}
