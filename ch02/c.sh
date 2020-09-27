name=$1; gcc -std=gnu11 -g ${name}.c -o ${name}_C && ./${name}_C 5 2 4 6 1 3; gdb ${name}_C -c core
