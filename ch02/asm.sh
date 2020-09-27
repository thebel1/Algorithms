name=$1; ulimit -c unlimited; nasm -f elf64 ${name}.asm && gcc -no-pie ${name}.o -o ${name}_Asm; ./${name}_Asm 5 2 4 6 1 3; gdb ${name}_Asm -c core
