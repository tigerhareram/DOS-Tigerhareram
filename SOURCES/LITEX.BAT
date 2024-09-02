@echo off
CD ..
mkdir OUTPUTS
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
