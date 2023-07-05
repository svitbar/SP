\masm32\bin\ml /c /coff 8-1-IM-12-Barytska-lib.asm
\masm32\bin\Link.exe /out:8-1-IM-12-Barytska-lib.dll /EXPORT:calculateMyExpression /DLL 8-1-IM-12-Barytska-lib.obj
\masm32\bin\ml /c /coff 8-1-IM-12-Barytska.asm
\masm32\bin\Link.exe /subsystem:windows 8-1-IM-12-Barytska.obj
pause