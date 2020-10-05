set print array off

set args 4 1 6 8 2 3

#break buildMaxHeap_loop
#commands
#    printf "i=%d\n", $r14d
#end

#break maxHeapify_if3
#commands
#    printf "[%d, %d]\n", $ecx, $edx
#end

#break *0x000000000040121c
#commands
#    py print([gdb.execute('p *((int*)$rdi)@6', to_string=True), \
#        int(gdb.parse_and_eval('$esi')), \
#        int(gdb.parse_and_eval('$ecx'))])
#end

break *0x0000000000401251
commands
    printf "%d ", $r14d
    print *((int*)$r12)@6
end

run