.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

showInfo macro num, a, c, b, d, final, error
invoke FloatToStr, myPersonalA[esi*8 - 8], addr buff_A
invoke FloatToStr, myPersonalB[esi*8 - 8], addr buff_B
invoke FloatToStr, myPersonalC[esi*8 - 8], addr buff_C
invoke FloatToStr, myPersonalD[esi*8 - 8], addr buff_D
invoke FloatToStr, final, addr buff_Res
invoke wsprintf, addr buff_show_caption, addr messageCaption, num
invoke wsprintf, addr buff_show_args, addr varArgs, addr buff_A, addr buff_B, addr buff_C, addr buff_D
.if error == 1
    invoke wsprintf, addr buff_show_final, addr error_zero
.elseif error == 2
    invoke wsprintf, addr buff_show_final, addr error_negative
.elseif error == 0
invoke wsprintf, addr buff_show_final, addr finalResult, addr buff_Res
.endif
invoke wsprintf, addr buff_All, addr output_text, addr myPersonalVar, addr buff_show_caption, addr buff_show_args, addr buff_show_final
invoke MessageBox, 0, addr buff_All, addr MsgBoxCaption, 0
endm

.data?
buff_All db 256 dup(?)
buff_A db 32 dup(?)
buff_B db 32 dup(?)
buff_C db 32 dup(?)
buff_D db 32 dup(?)
buff_Res db 32 dup(?)
buff_show_caption db 64 dup(?)
buff_show_args db 64 dup(?)
buff_show_final db 64 dup(?)

error db ?
numerator dq ?
denominator dq ?
root dq ?
result dq ?

.data
MsgBoxCaption db "Lab 6", 0

myPersonalVar db "Формула: (2*c-d+(23*b)^(1/2))/(a/4-1)", 0

myPersonalA dq 8.3, -12.7, 2.6, 18.5, 4.0, 81.5
myPersonalB dq 6.1, 1.2, 11.8, 56.7, 0.7, -35.9
myPersonalC dq 23.4, 3.4, 44.4, -63.7, -17.3, -32.4
myPersonalD dq -7.8, 58.2, 9.1, -1.4, -24.2, 71.6

messageCaption db "Контрольний приклад %d", 0
varArgs db "a = %s, b = %s, c = %s, d = %s", 0

finalResult db "Результат: %s", 0

error_error db "Помилка!", 0
error_zero db "Знаменник не може дорівнювати 0", 0
error_negative db "Значення під кореннем не може бути від'ємним", 0

output_text db "%s", 10, " ", 10, "%s", 10, "%s", 10, " ", 10, "%s", 0

one dq 1.0
two dq 2.0
four dq 4.0
twenty_three dq 23.0

.code
Lab_6:
mov esi, 0
.while esi < 6
    mov [error], 0
    finit

    fld myPersonalB[esi*8]              ;; root
    fld twenty_three
    fmul
    fsqrt
    fstp [root]

    fldz                              
    fld [root]                          
    fcom                            

    fstsw ax                           
    sahf                               
    
    jz root_has_negative

    fld myPersonalC[esi*8]              ;; 2c
    fld two
    fmul

    fld myPersonalD[esi*8]              ;; 2c - d
    fsub

    fld root                            ;; 2c - d + root
    fadd
    fstp [numerator]

    fld myPersonalA[esi*8]              ;; a/4
    fld four
    fdiv

    fld one                             ;; a/4 - 1
    fsub

    fstp [denominator]

    fldz                              
    fld [denominator]                          
    fcom                            

    fstsw ax                           
    sahf                               
    
    jz denominator_is_zero

    fld numerator
    fld denominator
    fdiv
    
    fstp [result]
    jmp all_done

    root_has_negative:
    mov [error], 2  
    jmp all_done
    
    denominator_is_zero:
    mov [error], 1    

    all_done:
    inc esi
    showInfo esi, myPersonalA[esi*8 - 8], myPersonalB[esi*8 - 8], \
    myPersonalC[esi*8 - 8], myPersonalD[esi*8 - 8], result, error
.endw

invoke ExitProcess, 0
end Lab_6