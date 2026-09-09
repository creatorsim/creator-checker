#
# ARCOS.INF.UC3M.ES
# BY-NC-SA (https://creativecommons.org/licenses/by-nc-sa/4.0/deed.es)
#


.text

main:
        addi sp, sp, -4
        sw ra, 0(sp)

        # t1 = factorial(5)
        li  a0, 5
        jal x1, factorial

        # print_int(t1)
        li  a7, 1
        ecall

        # return
        lw ra, 0(sp)
        addi sp, sp, 4
        li a7, 10
        ecall
