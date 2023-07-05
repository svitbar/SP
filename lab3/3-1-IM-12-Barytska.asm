.386
.model flat, stdcall
option casemap :none
include \masm32\include\masm32rt.inc

StartDialog PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data?

buff_Text db 16 dup(?)
buff_Password db 16 dup(?)

.data

MsgBoxCaption db "Lab 3", 0

dataCaption db "ПІБ:", 0
myData db "Барицька Світлана Вікторівна", 0
dateCaption db "Дата народження:", 0
myDate db "11.02.2004", 0
bookCaption db "Номер залікової книжки:", 0
myBook db "1202", 0
password db "Utopia", 0
failPassword db "Wrong password. Try again.", 0

output_text db "%s", 10, "%s", 10, " ", 10, "%s", 10, "%s", 10, " ", 10,"%s", 10,"%s", 10, " ", 0

.code
Lab_3:

Dialog "Лабораторна робота 3", "MS Sana Serif", 10, WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, 4, 50, 50, 200, 120, 1024

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
            call acceptPass
        .endif

    .elseif uMsg == WM_CLOSE
        quit_dialog:
        invoke EndDialog, hWin, 0
    .endif

    xor eax, eax
    ret

StartDialog endp

acceptPass proc

    mov esi, offset password
    mov edi, offset buff_Password
    mov ecx, 0

check_password:
    mov al, [esi]
    cmp al, [edi]
    jne wrong_password

    inc esi
    inc edi
    inc ecx

    cmp al, 0
    jne check_password

    invoke wsprintf, addr buff_Text, addr output_text, addr dataCaption, addr myData, addr dateCaption, addr myDate, addr bookCaption, addr myBook
    invoke MessageBox, 0, addr buff_Text, addr MsgBoxCaption, 0
    invoke ExitProcess, NULL

wrong_password:
    invoke MessageBox, 0, addr failPassword, addr MsgBoxCaption, 0
    jmp StartDialog

acceptPass endp

end Lab_3