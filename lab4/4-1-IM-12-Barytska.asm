.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc

showInfo macro caption, info                ; macro displays info
    ;; my hidden macro comment
    invoke wsprintf, addr buff_Text, addr output_text, addr caption, addr info
    invoke MessageBox, 0, addr buff_Text, addr MsgBoxCaption, 0
endm

checkIfRightLength macro                    ; macro checks pass's lehgth
  mov esi, offset buff_Password
  mov ecx, 0

  count_length:                             ;; length cycle
    cmp byte ptr [esi], 0
    je check_length

    inc esi
    inc ecx
    jmp count_length

  check_length:                             ;; final comparing
    cmp ecx, 6
endm

encryptWithXOR macro                        ; macro encrypts password
  mov esi, offset buff_Password
  mov edi, offset buff_EncPassword
  mov ecx, 0

  xor_encryption:                           ;; start encryption
    mov al, [esi]
    xor al, key
    mov [edi], al
    inc esi
    inc edi
    cmp byte ptr [esi], 0
    jne xor_encryption
    
endm

finalPassComparing macro                        ; macro for final actions
  ; initiate local labels
  LOCAL checking_pass, wrong_password, password_matched
  checkIfRightLength                            ;; checking length
  jne wrong_password                            

  mov esi, offset buff_EncPassword
  mov edi, offset password
  mov ecx, 0

  checking_pass:                                ;; comparing
    mov al, [esi]
    cmp al, [edi]
    jne wrong_password

    inc esi
    inc edi
    inc ecx

    cmp ecx, 6
    je password_matched

    cmp byte ptr [esi], 0
    jne checking_pass

  password_matched:                               ;; appropriate password
    showInfo dataCaption, myData
    showInfo dateCaption, myDate
    showInfo bookCaption, myBook
    invoke ExitProcess, NULL

  wrong_password:                                  ;; wrong password
    showInfo errorCaption, failPassword
    call StartDialog                               ; try again

endm

StartDialog PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data?

buff_Text db 16 dup(?)
buff_Password db 64 dup(?)
buff_EncPassword db 64 dup(?)

.data

MsgBoxCaption db "Lab 4", 0

dataCaption db "ПІБ:", 0
myData db "Барицька Світлана Вікторівна", 0
dateCaption db "Дата народження:", 0
myDate db "11.02.2004", 0
bookCaption db "Номер залікової книжки:", 0
myBook db "1202", 0
password db "Jkpov~", 0
key equ 1fh
errorCaption db "Error:", 0
failPassword db "Wrong password. Try again.", 0

output_text db "%s", 10, "%s", 0

.code
Lab_4:

Dialog "Лабораторна робота 4", "MS Sana Serif", 10, WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, 4, 50, 50, 200, 120, 1024

DlgEdit WS_BORDER, 40, 40, 120, 12, 1000

DlgButton "OK", WS_TABSTOP, 40, 70, 50, 15, IDOK

DlgButton "Скасувати", WS_TABSTOP, 110, 70, 50, 15, IDCANCEL

DlgStatic "Введіть пароль:", SS_CENTER, 30, 20, 140, 9, 100

CallModalDialog 0, 0, StartDialog, NULL

StartDialog proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    .if uMsg == WM_INITDIALOG
        invoke SendMessage, hWin, WM_SETICON, 1, FUNC(LoadIcon, NULL, IDI_ASTERISK)

    .elseif uMsg == WM_COMMAND
        .if wParam == IDCANCEL
            jmp quit_dialog
        .endif 
        .if wParam == IDOK
            invoke GetDlgItemText, hWin, 1000, addr buff_Password, 64
            encryptWithXOR
            finalPassComparing
        .endif

    .elseif uMsg == WM_CLOSE
        quit_dialog:
        invoke EndDialog, hWin, 0
    .endif

    xor eax, eax
    ret

StartDialog endp

end Lab_4
