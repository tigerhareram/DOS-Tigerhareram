;USERPORT.ASM -- customizable userport interface for MS-DOS C64 emulators
;link with the /t or /tiny switch to create a .COM program

CODE segment 'CODE'
assume CS:CODE,DS:CODE
org 100h
EntryPoint:
  jmp Main

;------------------------------------------------------------------------------
;Add your own variables here.

acEmulator db "PC64.EXE",0              ;path to C64 emulator
LPTNum equ 1                            ;the LPT used for output, from 1 to 4
wLPTPort dw ?                           ;the LPT's port address

;------------------------------------------------------------------------------
;The Init function is called once at startup when the emulator isn't running
;yet. If your special hardware can't be found, you should print out an error
;message and return to DOS.

Init proc near
  xor AX,AX                             ;get LPT port address
  mov ES,AX
  mov AX,ES:[0408h+(LPTNum-1)*2]
  cmp AX,0100h                          ;check for existence and network
  jb NoPort                             ; tricks
  test AL,00000011b
  jne NoPort
  mov wLPTPort,AX                       ;store the LPT port
  call Print                            ;Print() will continue program
  db "C64 Userport output is "          ; execution after the concluding 0
  db "now redirected to LPT",LPTNum+'0',13,10,0
  ret                                   ;return and run the emulator
NoPort:                                 ;the LPT port was not present or is
  call Print                            ; in use by a network
  db "Userport redirection error: LPT",LPTNum+'0'," not found!",13,10,0
  mov AX,4C01h                          ;back to DOS, don't run the emulator
  int 21h
Init endp

;------------------------------------------------------------------------------
;If you've used resources like interrupt vectors in the Init() function, you
;must release them here. Exit() is also the right place to reset your
;individual hardware.

Exit proc near
  ret                                   ;No resources used, simply return
Exit endp

;------------------------------------------------------------------------------
;The following functions are called by the emulator when the C64 program reads
;and writes the Userport or the IO area. Note that DS belongs to the emulator,
;so you cannot access variables via the data segment register. You must also
;preserve all registers except AX.

assume DS:nothing                       ;tell the assembler not to use DS

;------------------------------------------------------------------------------
;CIA 2 Port A:
;  Bit 2 = RS232 TXD out
;  Bit 3 = IEC ATN out
;  Bit 4 = IEC CLOCK out
;  Bit 5 = IEC DATA out
;  Bit 6 = IEC CLOCK in
;  Bit 7 = IEC DATA in
;The bits 0 and 1 are for the 16K VIC bank, you cannot change them here. Some
;emulators may also mask out the IEC bits 3 to 7, leaving only bit 2 for own
;purposes.

ReadDD00 proc far                       ;AL=PEEK(56576)
  mov AL,0                              ;return a dummy value
  ret
ReadDD00 endp

WriteDD00 proc far                      ;POKE 56576,AL
  ret
WriteDD00 endp

WriteDD02 proc far                      ;POKE 56578,AL
  ret
WriteDD02 endp

;------------------------------------------------------------------------------
;CIA 2 Port B:
;  Bit 0 = RS232 RXD in
;  Bit 1 = RS232 RTS out
;  Bit 2 = RS232 DTR out
;  Bit 3 = RS232 RI in
;  Bit 4 = RS232 DCD in
;  Bit 5 = free in
;  Bit 6 = RS232 CTS in
;  Bit 7 = RS232 DSR in
;This is the standard Userport register for 8 bit I/O. Remember to preserve
;everything except AX!

ReadDD01 proc far                       ;AL=PEEK(56577)
  mov AL,0                              ;sorry, no input in this example
  ret
ReadDD01 endp

WriteDD01 proc far                      ;POKE 56577,AL
  push DX
  mov DX,wLPTPort                       ;the assembler will use CS: here
  out DX,AL                             ;write the data byte to LPTx
  pop DX
  ret
WriteDD01 endp

WriteDD03 proc far                      ;POKE 56579,AL
  ret                                   ;direction register not used here
WriteDD03 endp

;------------------------------------------------------------------------------
;The following functions are called if a program accesses the IO range from
;$DE00 to $DF9F. BX contains the address. $DFA0 to $DFFF is reserved for
;recognizing C64 emulators. Don't forget to preserve everything except AX!

ReadIO proc far                         ;AL=PEEK(BX)
  mov AL,0
  ret
ReadIO endp

WriteIO proc far                        ;POKE BX,AL
  ret
WriteIO endp

;------------------------------------------------------------------------------
;This is private stuff which shouldn't be modified.

acIdentification db "C64 Emulator Userport Interface",0
apFunctions dw acIdentification
  dw ReadDD00,WriteDD00,WriteDD02
  dw ReadDD01,WriteDD01,WriteDD03
  dw ReadIO,WriteIO
;Emulator writers can add additional functions here, e.g. the Serial Data
;Registers $DC0C and $DD0C or user customizable keyboard and joystick mapping
;in $DC00 and $DC01. A individual identification string should precede those
;function blocks to avoid conflicts with other extensions. The emulator will
;stop searching for extensions when it reaches the NULL pointer.
  dw 0

NewInt2F proc
  cmp AX,0C640h
  jne NextHandler
  cmp DX,'UI'
  jne NextHandler
  mov AX,offset apFunctions             ;pass function pointers to emulator
  mov DX,CS                             ;same segment for all functions
  iret
NextHandler:
  db 0EAh                               ;jmp far ptr xxxx:xxxx
OldInt2F dw ?,?
NewInt2F endp

PrintSI proc near                       ;prints text in CS:SI until 0
  mov DL,CS:[SI]
  inc SI
  and DL,DL
  je Return
  mov AH,02h
  int 21h
  jmp PrintSI
Return:
  ret
PrintSI endp

Print proc near
  pop SI                                ;return address = start of string
  call PrintSI
  jmp SI                                ;jump behind the terminating 0
Print endp

wEnvSeg dw ?                            ;Parameter Block for function 4B00h
wCmdOfs dw 128
wCmdSeg dw ?
wFCB1Ofs dw 5Ch
wFCB1Seg dw ?
wFCB2Ofs dw 6Ch
wFCB2Seg dw ?

Main proc near
assume DS:code
ifdef DEBUG
  mov AH,0Dh                            ;prevent loss of source code
  int 21h
endif
  mov SP,ProgramSizeInParas*16+512      ;leave all memory for the emulator
  mov BX,ProgramSizeInParas+512/16
  mov AH,4Ah
  int 21h                               ;ES must be set to CS here
  mov AX,352Fh                          ;enable detection interrupt
  int 21h
  mov OldInt2F[0],BX
  mov OldInt2F[2],ES
  mov DX,offset NewInt2F
  mov AX,252Fh
  int 21h
  call Init
  mov AX,DS:[002Ch]                    ;execute emulator as child process
  mov wEnvSeg,AX
  mov wCmdSeg,CS
  mov wFCB1Seg,CS
  mov wFCB2Seg,CS
  mov BX,offset wEnvSeg
  push CS
  pop ES
  mov DX,offset acEmulator
  mov AX,4B00h
  int 21h
  jnc NoError
  mov SI,offset acEmulator
  call PrintSI
  call Print
  db ": error executing child process",13,10,0
NoError:
  call Exit
  mov DX,OldInt2F[0]                    ;restore detection interrupt
  mov DS,OldInt2F[2]
  mov AX,252Fh
  int 21h
  mov AH,4Dh                            ;pass emulator exit code
  int 21h
  mov AH,4Ch
  int 21h
Main endp

ProgramSizeInParas equ ($-EntryPoint+100h+15)/16
CODE ends
end EntryPoint
