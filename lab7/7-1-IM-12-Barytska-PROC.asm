.386
.model flat, stdcall
option casemap :none

public myDenominatorCalc
extern myPersonalA: QWORD, four: QWORD, one: QWORD

.code

myDenominatorCalc proc
    fld myPersonalA[esi*8]             ;; a/4
    fld four
    fdiv
    
    fld one                            ;; a/4 - 1
    fsub

    ret
myDenominatorCalc endp

end