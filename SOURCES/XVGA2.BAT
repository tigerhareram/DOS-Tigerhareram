@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\XVGA2
mkdir ..\OUTPUTS\XVGA2\DATA
mkdir ..\OUTPUTS\XVGA2\FONTS
COPY ..\SOURCES\FILES\XVGA2\DATA\*.* ..\OUTPUTS\XVGA2\DATA
COPY ..\SOURCES\FILES\XVGA2\FONTS\*.* ..\OUTPUTS\XVGA2\FONTS
CLS
echo --------------------------------------------------               * * * * *
echo  Building Program                                                * START *
echo --------------------------------------------------               * * * * *

bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\XVGA2\xvga2lib.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\XVGA2\xvga2.pas

COPY ..\OUTPUTS\xvga2.exe ..\OUTPUTS\XVGA2

cd ..\OUTPUTS\
