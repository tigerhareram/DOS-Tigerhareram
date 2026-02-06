comment @

Falls sich nach jedem Programmstart unter Windows der Star WinType 4000
Druckerdialog meldet ein Formfeed ausgeben will, muá in PC64.PIF das
"PC64.EXE" durch "NOGDI.COM" ersetzt werden.

--------------------------------------------------------------------
NOGDI.ASM -- resolves conflict between PC64 and the WinType 4000 VxD
--------------------------------------------------------------------

A thoroughbred GDI laser printer as the Star WinType 4000 does no more
understand standard languages like PCL, because it has no CPU and no memory
(OK, that's not 100 percent true <g>). Although it is connected to a standard
LPT port, it cannot print under plain DOS.

In a Windows DOS box, the SUMOVMI.386 VxD grabs the data from the assigned LPT
port and passes it to either a PCL or a PostScript interpreter. This
background program builds the page as a Windows bitmap and then passes it to
the GDI printer driver. The GDI printer driver will then write the data to the
real LPT port. This means:

a) you can buy a 300 dpi laser printer with 12 MBytes of RAM for only $500 :-)

b) printer data written in a DOS box directly to the assigned LPT port will
never reach that port physically.

The problem is: Such a VxD must recognize if the DOS application either wants
to print or to do something else with the LPT port, e.g. autodetect a C64
which is connected via the PC64 emulator cable. The distinguation could be
made by monitoring the STROBE line. If it goes from high to low, then pass the
data byte to the PCL interpreter. Otherwise throw it away. (Or optionally
output it to the data port if you share the LPT between printer and C64. Of
course, this requires that the Star developers did not abuse the data lines
for controlling, and will also cause problems interpreting the input from the
status lines.)

Obviously, the SUMOVMI.386 driver Version 2.0 does not follow this logic. If
you write something to the LPT data port without touching the control port, a
real printer will do nothing. The SUMOVMI.386 driver instead passes a Form Feed
to the PCL interpreter, causing it to to pop up the printer status dialog and
display an error message because the WinType 4000 on LPT2 is off. So each time
the PC64 emulator is run in a Windows DOS box, this irksome error message pops
up.

The second problem is even worse: Although the SUMOVMI.386 is only allowed to
hook LPT2 (the port where the WinType 4000 is connected to), it influences
also LPT1. Thus, the transmission in PC64 over LPT1 does not work. If you
comment out the SUMOVMI.386 entry in System.INI\[386Enh] and restart Windows,
the transmission works fine.

This conflict can be solved by OR'ing the LPT port address with 8000h. So your
application can bypass the VxD and access the port directly. This works fine,
because most LPT cards have only 10 address lines. So 0378h and 8378h are in
fact the same address.

Before loading the emulator, NOGDI.COM is OR'ing all meaningful LPT port
addresses in the BIOS data area at 0000:0408h. After finishing the main
application, NOGDI.COM restores these values and exits. If you have problems
with PC64 and GDI printer drivers, replace PC64.EXE by NOGDI.COM in PC64.PIF.

(please link with the /t or /tiny switch to create a COM program).
@

CODE segment 'CODE'
assume CS:CODE,DS:CODE
org 100h
EntryPoint:
  jmp Main

acApp db "PC64.EXE",0                   ;path to main application

wEnvSeg dw ?                            ;Parameter Block for function 4B00h
wCmdOfs dw 128
wCmdSeg dw ?
wFCB1Ofs dw 5Ch
wFCB1Seg dw ?
wFCB2Ofs dw 6Ch
wFCB2Seg dw ?

Main proc near
ifdef DEBUG
  mov AH,0Dh                            ;prevent loss of source code
  int 21h
endif
  xor BX,BX                             ;BIOS data area
  mov ES,BX
NextOr:
  mov AX,ES:[0408h+BX]
  cmp AX,0100h                          ;check for existence and network
  jb NoOr                               ; tricks
  test AL,00000011b
  jne NoOr
  or AX,8000h                           ;the port address is OK
  mov ES:[0408h+BX],AX
NoOr:
  add BL,2
  cmp BL,8                              ;handle LPTs 1 to 4
  jb NextOr
  mov SP,ProgramSizeInParas*16+512      ;leave all memory to the application
  push CS
  pop ES
  mov BX,ProgramSizeInParas+512/16
  mov AH,4Ah
  int 21h
  mov AX,DS:[002Ch]                     ;execute application as child process
  mov wEnvSeg,AX
  mov wCmdSeg,CS
  mov wFCB1Seg,CS
  mov wFCB2Seg,CS
  mov BX,offset wEnvSeg
  push CS
  pop ES
  mov DX,offset acApp
  mov AX,4B00h
  int 21h
  jnc NoError
  mov DX,offset ExecError
  mov AH,09h
  int 21h
NoError:
  xor BX,BX                             ;BIOS data area
  mov ES,BX
NextAnd:
  mov AX,ES:[0408h+BX]
  and AX,not 8000h
  cmp AX,0100h                          ;check for existence and network
  jb NoAnd                              ; tricks
  test AL,00000011b
  jne NoAnd
  mov ES:[0408h+BX],AX                  ;the port address is OK
NoAnd:
  add BL,2
  cmp BL,8                              ;handle LPTs 1 to 4
  jb NextAnd
  mov AH,4Dh                            ;pass the exit code through
  int 21h
  mov AH,4Ch
  int 21h
Main endp

ExecError db "Cannot execute child process!",13,10,'$'

ProgramSizeInParas equ ($-EntryPoint+100h+15)/16
CODE ends
end EntryPoint
