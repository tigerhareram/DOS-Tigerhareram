@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\XVGA
mkdir ..\OUTPUTS\XVGA\DATA
COPY ..\SOURCES\FILES\XVGA\DATA\*.* ..\OUTPUTS\XVGA\DATA
CLS
echo --------------------------------------------------               * * * * *
echo  Building Program                                                * START *
echo --------------------------------------------------               * * * * *

bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\XVGA\xvga_lib.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\XVGA\xvga.pas

COPY ..\OUTPUTS\xvga.exe ..\OUTPUTS\XVGA

cd ..\OUTPUTS\
