name=$1; args="${@:2}"; gcc -std=gnu11 -g ${name}.c -o ${name}_C && ./${name}_C ${args}; gdb ${name}_C -c core
