.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc

showResult macro num, a, c, d, first, final, isError
invoke wsprintf, addr buff_show_var, addr myPersonalVar
invoke wsprintf, addr buff_show_caption, addr messageCaption, num
invoke wsprintf, addr buff_show_args, addr varArgs, a, c, d
.if isError == 1
    invoke wsprintf, addr buff_show_first, addr firstResult, first
    invoke wsprintf, addr buff_show_final, addr finalResult, final
 .else
    invoke wsprintf, addr buff_show_first, addr error_error
    invoke wsprintf, addr buff_show_final, addr error_cannot
 .endif
invoke wsprintf, addr buff_All, addr output_text, addr buff_show_var, \
addr buff_show_caption, addr buff_show_args, addr buff_show_first, \
addr buff_show_final
invoke MessageBox, 0, addr buff_All, addr MsgBoxCaption, 0
endm

.data?
buff_All db 256 dup(?)
buff_show_var db 32 dup(?)
buff_show_caption db 32 dup(?)
buff_show_args db 32 dup(?)
buff_show_first db 32 dup(?)
buff_show_final db 32 dup(?)

numerator dd ?
denominator dd ?
result dd ?
finalRes dd ?
error db ?

.data
MsgBoxCaption db "Lab 5", 0

myPersonalVar db "Формула: (c-d/2+33)/(2*a*a-9)", 0

myPersonalA dd -3, 2, -1, 7, -4, 3
myPersonalC dd 23, -127, -9, -318, 140, 10
myPersonalD dd -14, 20, 6, 142, -68, 4

messageCaption db "Контрольний приклад %d", 0
varArgs db "a = %d, c = %d, d = %d", 0

firstResult db "Проміжний результат: %d", 0
finalResult db "Остаточний результат: %d", 0

error_error db "Помилка!", 0
error_cannot db "Знаменник не може дорівнювати 0", 0

output_text db "%s", 10, " ", 10, "%s", 10, "%s", 10, " ", 10, "%s", 10, " ", "%s",0
.code
Lab_5:
mov esi, 0
.while esi < 6
    mov eax, myPersonalA[esi*4]
    mov ebx, myPersonalC[esi*4]
    mov edx, myPersonalD[esi*4]
    mov [numerator], edx
    neg [numerator]
    sar [numerator], 1
    add [numerator], ebx
    add [numerator], 33

    imul eax, eax
    mov [denominator], eax
    sal [denominator], 1

    .if esi == 5
        sub [denominator], 18
    .else 
        sub [denominator], 9
    .endif
    
    cmp [denominator], 0
    je denominator_is_zero

    mov [error], 1

    mov eax, [numerator]
    mov ebx, [denominator]
    cdq 
    idiv ebx
    mov [result], eax

    mov [finalRes], eax
    test [finalRes], 1
    jz number_is_even

    mov ebx, [finalRes]
    cdq
    imul ebx, 5
    mov [finalRes], ebx
    jmp all_done

    number_is_even:
    sar [finalRes], 1    
    jmp all_done

    denominator_is_zero:
    mov [error], 0
 
    all_done:
    inc esi
    showResult esi, myPersonalA[esi*4 - 4], myPersonalC[esi*4 - 4], myPersonalD[esi*4 - 4], result, finalRes, error
.endw

invoke ExitProcess, 0
end Lab_5