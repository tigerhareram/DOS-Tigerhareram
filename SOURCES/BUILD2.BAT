@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\WORLD2
mkdir ..\OUTPUTS\WORLD2\INT21H
mkdir ..\OUTPUTS\WORLD2\KNIHOVNA

CLS
echo --------------------------------------------------               * * * * *
echo  Copy Files Graphics & Audio ...                                 * START *
echo --------------------------------------------------               * * * * *

COPY ..\SOURCES\FILES\INT21H\*.* ..\OUTPUTS\WORLD2\INT21H\
COPY ..\SOURCES\FILES\WORLD2\KNIHOVNA\*.* ..\OUTPUTS\WORLD2\KNIHOVNA\
CLS
echo ----------------------------------------------------             * * * * *
echo  Building JIVA Programming Tools & Projects World 2              * START *
echo ----------------------------------------------------             * * * * *
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

bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x01_glob.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x02_ram.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x03_dos.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x04_vga.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x05_svga.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x06_3dfx.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x07_text.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x08_maps.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x09_time.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x10_sb16.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x11_kbd1.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x12_kbd2.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x13_mous.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x14_math.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x15_ipx.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\LITEX\x16_misc.pas

bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a01_vari.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a02_init.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a03_scra.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a04_scrb.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a05_scrc.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a06_scrd.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a07_edt1.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a08_edt2.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a09_pros.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a10_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a11_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a12_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a13_ma_s.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a14_ma_w.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a15_serv.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD2\a16_wrld.pas

COPY ..\OUTPUTS\a16_wrld.exe ..\OUTPUTS\WORLD2\
