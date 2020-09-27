name=$1; args="${@:2}"; ulimit -c unlimited; nasm -f elf64 ${name}.asm && gcc -no-pie ${name}.o -o ${name}_Asm; ./${name}_Asm ${args}; gdb ${name}_Asm -c core
