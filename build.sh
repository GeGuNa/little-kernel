nasm -f bin ./boot/boot.asm -o ./object/boot.bin

#gcc -fno-stack-protector -fno-pic  -m32 -ffreestanding -O2 -Wall -Wextra -DARCHITECTURE=1 -c ./modules/monitor.c -o ./object/monitor.o

gcc -fno-pic  -m32 -ffreestanding -O2 -Wall -Wextra -DARCHITECTURE=1 -c ./modules/monitor.c -o ./object/monitor.o


gcc  -fno-pic  -m32 -ffreestanding -O2 -Wall -Wextra -DARCHITECTURE=1 -c ./modules/ioports.c -o ./object/ioports.o

gcc -fno-pic  -m32 -ffreestanding -O2 -Wall -Wextra -DARCHITECTURE=1 -c ./kernel.c -o ./object/kernel.o

ld -nostdlib -m elf_i386 -T link.ld   ./object/kernel.o ./object/monitor.o ./object/ioports.o   -o ./object/kernel.bin


#gcc -fno-pic -m16 -ffreestanding -Wall -Wextra -c ./kernel.c -o ./object/kernel.o
#ld -e kernel -m elf_i386  -o ./object/kernel.bin -Ttext 0x9000 ./object/kernel.o --oformat binary 


#ld -m elf_i386 -T link.ld   ./object/kernel.o  -o ./object/kernel.bin

#ld -m elf_i386 -shared -fstack-protector -o ./object/kernel.bin -Ttext 0x9000 ./object/monitor.o ./object/ioports.o ./object/kernel.o --oformat binary 



cat ./object/boot.bin ./object/kernel.bin > ./kernel.os

qemu-system-i386 -hda ./kernel.os  -m 256
