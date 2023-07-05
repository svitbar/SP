.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

.data?
buff_All db 256 dup(?)
buff_D_Pos db 32 dup(?)
buff_D_Neg db 32 dup(?)
buff_E_Pos db 32 dup(?)
buff_E_Neg db 32 dup(?)
buff_F_Pos db 32 dup(?)
buff_F_Neg db 32 dup(?)

.data
MsgBoxCaption db "Lab 1", 0

symbol db "Symbol string:", 0

date db "11022004", 0

integer db "Integer numbers:", 0

A_Byte_Pos db 11
A_Byte_Neg db -11

A_Word_Pos dw 11
A_Word_Neg dw -11

A_ShortInt_Pos dd 11
A_ShortInt_Neg dd -11

A_LongInt_Pos dq 11
A_LongInt_Neg dq -11

B_Word_Pos dw 1102
B_Word_Neg dw -1102

B_ShortInt_Pos dd 1102
B_ShortInt_Neg dd -1102

B_LongInt_Pos dq 1102
B_LongInt_Neg dq -1102

C_ShortInt_Pos dd 11022004
C_ShortInt_Neg dd -11022004

C_LongInt_Pos dq 11022004
C_LongInt_Neg dq -11022004

float db "Float numbers:", 0 

D_Single_Pos dd 0.009
D_Single_Neg dd -0.009

D_Double_Pos dq 0.009
D_Double_Neg dq -0.009

D_Extended_Pos dt 0.009
D_Extended_Neg dt -0.009

E_Double_Pos dq 0.917
E_Double_Neg dq -0.917

F_Double_Pos dq 9169.720
F_Double_Neg dq -9169.720

F_Extended_Pos dt 9169.720
F_Extended_Neg dt -9169.720

output_text db "%s",10," ",10,"%s",10," ",10,"%s",10," ",10,"A = %d",10,"-A = %d",10,"B = %d",10,"-B = %d",10,"C= %d",10,"-C = %d",10," ",10,"%s",10," ",10,"D = %s",10,"-D = %s",10,"E = %s",10,"-E = %s",10,"F = %s",10,"-F = %s", 0

.code
Lab_1:
fld D_Extended_Pos
invoke FpuFLtoA, 0, 3, ADDR buff_D_Pos, SRC1_FPU or SRC2_DIMM
fld D_Extended_Neg
invoke FpuFLtoA, 0, 3, ADDR buff_D_Neg, SRC1_FPU or SRC2_DIMM
invoke FloatToStr2, E_Double_Pos, addr buff_E_Pos
invoke FloatToStr2, E_Double_Neg, addr buff_E_Neg
invoke FloatToStr2, F_Double_Pos, addr buff_F_Pos
invoke FloatToStr2, F_Double_Neg, addr buff_F_Neg
invoke wsprintf, addr buff_All, addr output_text, addr symbol, addr date, addr integer, A_ShortInt_Pos, A_ShortInt_Neg, B_ShortInt_Pos, B_ShortInt_Neg, C_ShortInt_Pos, C_ShortInt_Neg, addr float, addr buff_D_Pos, addr buff_D_Neg, addr buff_E_Pos, addr buff_E_Neg, addr buff_F_Pos, addr buff_F_Neg
invoke MessageBox, 0, addr buff_All, addr MsgBoxCaption, 0
invoke ExitProcess, 0
end Lab_1