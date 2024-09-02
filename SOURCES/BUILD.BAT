@echo off

CLS
echo --------------------------------------------------               * * * * *
echo  Building Directories                                            * START *
echo --------------------------------------------------               * * * * *

mkdir ..\OUTPUTS
mkdir ..\OUTPUTS\WORLD
mkdir ..\OUTPUTS\WORLD\BITMAP
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\1hit100A
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\1hit100A\GIF
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\2hit100B
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\2hit100B\GIF
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\3hit100C
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\3hit100C\GIF
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\4hit100D
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\5hit50
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\6hit25A
mkdir ..\OUTPUTS\WORLD\BITMAP\LSD\7hit25B

CLS
echo --------------------------------------------------               * * * * *
echo  Copy Files Graphics & Audio ...                                 * START *
echo --------------------------------------------------               * * * * *

COPY ..\SOURCES\FILES\BITMAP\*.* ..\OUTPUTS\WORLD\BITMAP\
COPY ..\SOURCES\FILES\BITMAP\LSD\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\
COPY ..\SOURCES\FILES\BITMAP\LSD\1hit100A\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\1hit100A\
COPY ..\SOURCES\FILES\BITMAP\LSD\1hit100A\GIF\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\1hit100A\GIF\
COPY ..\SOURCES\FILES\BITMAP\LSD\2hit100B\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\2hit100B\
COPY ..\SOURCES\FILES\BITMAP\LSD\2hit100B\GIF\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\2hit100B\GIF\
COPY ..\SOURCES\FILES\BITMAP\LSD\3hit100C\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\3hit100C\
COPY ..\SOURCES\FILES\BITMAP\LSD\3hit100C\GIF\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\3hit100C\GIF\
COPY ..\SOURCES\FILES\BITMAP\LSD\4hit100D\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\4hit100D\
COPY ..\SOURCES\FILES\BITMAP\LSD\5hit50\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\5hit50\
COPY ..\SOURCES\FILES\BITMAP\LSD\6hit25A\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\6hit25A\
COPY ..\SOURCES\FILES\BITMAP\LSD\7hit25B\*.* ..\OUTPUTS\WORLD\BITMAP\LSD\7hit25B\

CLS
echo --------------------------------------------------               * * * * *
echo  Building JIVA Programming Tools & Projects World                * START *
echo --------------------------------------------------               * * * * *
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

bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a01_vari.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a02_init.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a03_scra.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a04_scrb.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a05_scrc.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a06_scrd.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a07_edt1.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a08_edt2.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a09_pros.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a10_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a11_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a12_prow.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a13_ma_s.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a14_ma_w.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a15_serv.pas
bpc -Q -E..\OUTPUTS ..\SOURCES\WORLD\a16_wrld.pas

COPY ..\OUTPUTS\a16_wrld.exe ..\OUTPUTS\WORLD\