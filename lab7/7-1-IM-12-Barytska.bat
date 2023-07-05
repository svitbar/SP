@echo off

\masm32\bin\ml /c /coff 7-1-IM-12-Barytska.asm

\masm32\bin\ml /c /coff 7-1-IM-12-Barytska-PROC.asm

\masm32\bin\link /SUBSYSTEM:windows 7-1-IM-12-Barytska.obj 7-1-IM-12-Barytska-PROC.obj
7-1-IM-12-Barytska.exe