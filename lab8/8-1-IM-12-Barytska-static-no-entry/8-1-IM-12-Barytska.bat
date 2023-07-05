\masm32\bin\ml /c /coff 8-1-IM-12-Barytska-lib.asm
\masm32\bin\Link.exe /out:8-1-IM-12-Barytska-lib.dll /DEF:8-1-IM-12-Barytska-lib.def /DLL 8-1-IM-12-Barytska-lib.obj /NOENTRY
\masm32\bin\ml /c /coff 8-1-IM-12-Barytska.asm
\masm32\bin\Link.exe /subsystem:windows 8-1-IM-12-Barytska.obj
pause