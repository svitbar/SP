.386
.model flat, stdcall
option casemap :none

.data?

    denominator dq ?
    numerator dq ?
    root dq ?

.data

    zero dq 0.0
    one dq 1.0
    two dq 2.0
    four dq 4.0
    twenty_three dq 23.0

.code

myFavLib proc hInstDLL: dword, reason: dword, notfornow: dword
    finit
    mov eax, 1
    
    ret
myFavLib endp

calculateMyExpression proc aValue: ptr qword, bValue: ptr qword, cValue: ptr qword, dValue: ptr qword, finalResult: ptr qword
    mov eax, 0

    finit
    
    mov ebx, bValue         ;; root
    fld qword ptr[ebx]
    fld twenty_three
    fmul
    fsqrt

    fcom zero
    
    fstsw ax
    sahf
    
    jz root_has_negative

    fstp [root]

    mov ebx, cValue          ;; 2c
    fld qword ptr[ebx]
    fld two
    fmul

    mov ebx, dValue         ;; 2c - d
    fld qword ptr[ebx]
    fsub

    fld root                ;; 2c - d + root
    fadd
    fstp [numerator]

    mov ebx, aValue         ;; a/4
    fld qword ptr[ebx]
    fld four
    fdiv
    
    fld one                 ;; a/4 - 1
    fsub

    fcom zero
    
    fstsw ax
    sahf
    
    jz denominator_is_zero
    
    fstp [denominator]

    fld [numerator]
    fld [denominator]
    fdiv
    
    jmp all_done

    root_has_negative:
        mov eax, 2
        jmp all_done

    denominator_is_zero:
        mov eax, 1

    all_done:
        mov ecx, finalResult
        fstp qword ptr [ecx]

    ret

calculateMyExpression endp

end myFavLib