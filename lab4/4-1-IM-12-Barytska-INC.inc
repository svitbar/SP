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