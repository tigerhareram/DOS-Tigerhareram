@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\VGA_DEMO
mkdir ..\OUTPUTS\VGA_DEMO\INT21H
mkdir ..\OUTPUTS\VGA_DEMO\DATA
COPY ..\SOURCES\FILES\VGA_DEMO\DATA\*.* ..\OUTPUTS\VGA_DEMO\DATA\
CLS
echo --------------------------------------------------               * * * * *
echo  Building Program                                                * START *
echo --------------------------------------------------               * * * * *


bpc -Q -E..\OUTPUTS ..\SOURCES\VGA_DEMO\vga_lib.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\VGA_DEMO\vga_demo.pas

COPY ..\OUTPUTS\vga_demo.exe ..\OUTPUTS\VGA_DEMO
