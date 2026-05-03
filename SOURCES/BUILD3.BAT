@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\WORLD3
mkdir ..\OUTPUTS\WORLD3\INT21H
mkdir ..\OUTPUTS\WORLD3\KNIHOVNA

CLS
echo --------------------------------------------------               * * * * *
echo  Copy Files Graphics & Audio ...                                 * START *
echo --------------------------------------------------               * * * * *

COPY ..\SOURCES\FILES\INT21H\*.* ..\OUTPUTS\WORLD3\INT21H\
COPY ..\SOURCES\FILES\WORLD3\KNIHOVNA\*.* ..\OUTPUTS\WORLD3\KNIHOVNA\
CLS
echo ----------------------------------------------------             * * * * *
echo  Building JIVA Programming Tools & Projects World 3              * START *
echo ----------------------------------------------------             * * * * *
CD ..
CD BORLAND
mkdir ..\BORLAND\UNITS\FONTS
COPY ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\FONTS\*.* ..\BORLAND\UNITS\FONTS\
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\adler32.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\crc32.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\fontgrab.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\gr_vars.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\gr_8bit.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\gr_hicol.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\grafx.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\fadelib.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\inflate.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\mousedr7.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\pngunit.pas
bpc /O..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\ -b -Q -E..\BORLAND\UNITS\ ..\SOURCES\LITEX\STORE\05-XVGA\GRAFX\vesademo.pas
CD ..
CD OUTPUTS

tasm -m9 -t ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_spoly1.asm
tasm -m9 -t ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_spoly2.asm
tasm -m9 -t ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_vector.asm
tasm -m9 -t ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_xform.asm
tasm -m9 -t ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_matrix.asm

bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_types.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_polygo.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_memory.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_bufio.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_pcx.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_shade.pas
bpc -b -Q -E..\OUTPUTS\ ..\SOURCES\LITEX\STORE\06-3DFX\SOURCE\i_inerti.pas

bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\STORE\10-SB16\SMIX\SOURCE\b_xms.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\STORE\10-SB16\SMIX\SOURCE\b_detect.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\STORE\10-SB16\SMIX\SOURCE\b_smix.pas

bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x01_glob.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x02_ram.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x03_dos.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x04_vga.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x05_svga.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x05_xvga.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x06_3dfx.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x07_text.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x08_maps.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x09_time.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x10_sb16.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x11_kbd1.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x12_kbd2.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x13_mous.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x14_math.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x15_ipx.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\LITEX\x16_misc.pas

bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a01_vari.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a02_init.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a03_scra.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a04_scrb.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a05_scrc.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a06_scrd.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a07_edt1.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a08_edt2.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a09_pros.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a10_prow.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a11_prow.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a12_prow.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a13_ma_s.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a14_ma_w.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a15_serv.pas
bpc /U..\BORLAND\UNITS\ -Q -E..\OUTPUTS ..\SOURCES\WORLD3\a16_wrld.pas

COPY ..\OUTPUTS\a16_wrld.exe ..\OUTPUTS\WORLD3\
cd ..\OUTPUTS\
