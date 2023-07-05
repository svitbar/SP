.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc

includelib 8-1-IM-12-Barytska-lib.lib

calculateMyExpression proto :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword
showInfo macro num, a, b, c, d, final, error
invoke FloatToStr, a, addr buff_A
invoke FloatToStr, b, addr buff_B
invoke FloatToStr, c, addr buff_C
invoke FloatToStr, d, addr buff_D
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

finalRes dq 1 dup(?)
error db ?

.data
MsgBoxCaption db "Lab 8", 0

myPersonalVar db "Формула: (2*c-d+(23*b)^(1/2))/(a/4-1)", 0

myPersonalA dq 8.3, -12.7, 2.6, 18.5, 4.0, 81.5
myPersonalB dq 6.1, 1.2, 11.8, 56.7, 0.7, -35.9
myPersonalC dq 23.4, 3.4, 44.4, -63.7, -17.3, -32.4
myPersonalD dq -7.8, 58.2, 9.1, -1.4, -24.2, 71.6

messageCaption db "Контрольний приклад %d", 0
varArgs db "a = %s, b = %s, c = %s, d = %s", 0

finalResult db "Результат: %s", 0

error_zero db "Знаменник не може дорівнювати 0", 0
error_negative db "Значення під кореннем не може бути від'ємним", 0

output_text db "%s", 10, " ", 10, "%s", 10, "%s", 10, " ", 10, "%s", 0

.code
Lab_8:
mov esi, 0
.while esi < 6

    invoke calculateMyExpression, addr myPersonalA[esi*8], addr myPersonalB[esi*8], \
    addr myPersonalC[esi*8], addr myPersonalD[esi*8], addr finalRes

    cmp eax, 0
    je approved

    cmp eax, 1
    je denominator_is_zero

    cmp eax, 2
    je root_has_negative

    approved:
    mov [error], 0
    jmp all_done

    denominator_is_zero:
    mov [error], 1
    jmp all_done

    root_has_negative:
    mov [error], 2
    jmp all_done

    all_done:
    inc esi
    showInfo esi, myPersonalA[esi*8 - 8], myPersonalB[esi*8 - 8], \
    myPersonalC[esi*8 - 8], myPersonalD[esi*8 - 8], finalRes, error
.endw

invoke ExitProcess, 0
end Lab_8