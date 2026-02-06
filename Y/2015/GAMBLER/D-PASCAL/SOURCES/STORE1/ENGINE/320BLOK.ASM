[SECTION ._TEXT]
%define PASCAL
%include "C:\SOURCES\STORE1\MACROS\c16.mac"

proc Blok

%$BufferTo arg
%$Color arg
%$y2 arg
%$x2 arg
%$y1 arg
%$x1 arg

  JMP  @start

@kresli4:
  MOV  AX,  SI
  MOV  BX,  [BP+%$y1]
  MUL  BX                    ; AX := y1*320
  MOV  CX,  [BP+%$x1]
  ADD  AX,  CX               ; AX := y1*320+x1
  XOR  EDI, EDI
  MOV  DI,  AX               ; ES:DI := offset

  XOR  EAX, EAX
  MOV  BX,  [BP+%$Color]     ; BL = Color
  MOV  AX,  BX
  XOR  AH,  AH               ; EAX = 00000000 00000000 00000000 1color01
  SHL  EAX, 8                ; EAX = 00000000 00000000 1color01 00000000
  MOV  AL,  BL               ; EAX = 00000000 00000000 1color01 1color01
  SHL  EAX, 8                ; EAX = 00000000 1color01 1color01 00000000
  MOV  AL,  BL               ; EAX = 00000000 1color01 1color01 1color01
  SHL  EAX, 8                ; EAX = 1color01 1color01 1color01 00000000
  MOV  AL,  BL               ; EAX = 1color01 1color01 1color01 1color01

  MOV  BX,  [BP+%$y2]
  MOV  DX,  [BP+%$y1]
  SUB  BX,  DX
  INC  BX                    ; BX = vyska

  MOV  DX,  GS               ; DX = delka

@cyklus2:
  MOV  CX,  FS               ; CX = pocet STOSD cyklu

@cyklus1:
  STOSD
  LOOP @cyklus1
  MOV  CX,  BX
  SUB  DI,  DX
  ADD  DI,  SI
  DEC  BX
  LOOP @cyklus2
  RET

@kresli1:
  MOV  AX,  SI
  MOV  BX,  [BP+%$y1]
  MUL  BX                    ; AX := y1*320
  MOV  CX,  [BP+%$x1]
  ADD  AX,  CX               ; AX := y1*320+x1
  XOR  EDI, EDI
  MOV  DI,  AX               ; ES:DI := offset

  XOR  AX,  AX
  INC  AX
  MOV  BX,  GS
  CMP  BX,  AX
  JE   @mensi1

  MOV  AX,  GS               ; + delka
  ADD  DI,  AX

@mensi1:
  MOV  AX,  FS
  ADD  DI,  AX

  MOV  AX,  [BP+%$Color]     ; AL = Color

  MOV  BX,  [BP+%$y2]
  MOV  DX,  [BP+%$y1]
  SUB  BX,  DX
  INC  BX                    ; BX = vyska

  MOV  CX,  BX               ; CX = pocet cyklu
@cyklus3:
  STOSB
  DEC  DI
  ADD  DI,  SI
  LOOP @cyklus3

  RET

@start:
  MOV  AX,  [BP+%$Buffer]
  MOV  ES,  AX               ; ES := segment bufferu

  XOR  AX,  AX
  INC  AX
  SHL  AX,  8
  XOR  CX,  CX
  INC  CX
  SHL  CX,  6
  ADD  AX,  CX               ; AX := 320
  MOV  SI,  AX               ; SI := 320

  MOV  AX,  [BP+%$x2]
  MOV  CX,  [BP+%$x1]
  SUB  AX,  CX
  INC  AX                    ; AX = delka
  MOV  BX,  AX               ; BX = delka

  SHR  BX,  2
  MOV  FS,  BX               ; FS = pocet cyklu STOSD

  MOV  GS,  AX               ; GS = delka

  XOR  CX,  CX
  INC  CX
  SHL  CX,  2                ; CX := 4
  CMP  AX,  CX
  JB   @mensi4

  SHL  AX,  14
  SHR  AX,  14
  JMP  @continue

@mensi4:
  XOR  CX,  CX
  INC  CX
  MOV  GS,  CX

@continue:
  XOR  CX,  CX
  CMP  AX,  CX
  JE   @zbytek0              ; 000000000000xx AX=0
  INC  CX
  CMP  AX,  CX
  JE   @zbytek1              ; 000000000000xx AX=1
  INC  CX
  CMP  AX,  CX
  JE   @zbytek2              ; 000000000000xx AX=2
  INC  CX
  CMP  AX,  CX
  JE   @zbytek3              ; 000000000000xx AX=3

@zbytek0:
  CALL @kresli4
  JMP  @konec

@zbytek1:
  XOR  AX,  AX
  INC  AX
  MOV  BX,  GS
  CMP  BX,  AX
  JE   @mensi4zb1
  MOV  AX,  GS
  DEC  AX
  MOV  GS,  AX
  CALL @kresli4
@mensi4zb1:
  XOR  AX, AX
  MOV  FS, AX
  CALL @kresli1
  JMP  @konec

@zbytek2:
  XOR  AX,  AX
  INC  AX
  MOV  BX,  GS
  CMP  BX,  AX
  JE   @mensi4zb2
  MOV  AX,  GS
  DEC  AX
  DEC  AX
  MOV  GS,  AX
  CALL @kresli4
@mensi4zb2:
  XOR  AX, AX
  MOV  FS, AX
  CALL @kresli1
  XOR  AX, AX
  INC  AX
  MOV  FS, AX
  CALL @kresli1
  JMP  @konec

@zbytek3:
  XOR  AX,  AX
  INC  AX
  MOV  BX,  GS
  CMP  BX,  AX
  JE   @mensi4zb3
  MOV  AX,  GS
  DEC  AX
  DEC  AX
  DEC  AX
  MOV  GS,  AX
  CALL @kresli4
@mensi4zb3:
  XOR  AX, AX
  MOV  FS, AX
  CALL @kresli1
  XOR  AX, AX
  INC  AX
  MOV  FS, AX
  CALL @kresli1
  XOR  AX, AX
  INC  AX
  INC  AX
  MOV  FS, AX
  CALL @kresli1
  JMP  @konec
@konec:

endproc