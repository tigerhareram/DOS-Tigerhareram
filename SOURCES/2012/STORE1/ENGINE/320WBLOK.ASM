[SECTION ._TEXT]
%define PASCAL
%include "C:\SOURCES\STORE1\MACROS\c16.mac"

proc WriteBlok

%$BufferTo arg
%$BufferFrom arg
%$y3 arg
%$x3 arg
%$y2 arg
%$x2 arg
%$y1 arg
%$x1 arg

  PUSH DS
  JMP  @start

@kresli4:
  MOV  AX,  320
  MOV  BX,  [BP+%$y1]
  MUL  BX                    ; AX := y1*320
  MOV  CX,  [BP+%$x1]
  ADD  AX,  CX               ; AX := y1*320+x1
  XOR  EDI, EDI
  MOV  DI,  AX               ; ES:DI := offset

  MOV  AX,  320
  MOV  BX,  [BP+%$y2]
  MUL  BX                    ; AX := y2*320
  MOV  CX,  [BP+%$x2]
  ADD  AX,  CX               ; AX := y2*320+x2
  XOR  ESI, ESI
  MOV  SI,  AX               ; DS:SI := offset

  MOV  BX,  [BP+%$y3]
  MOV  DX,  [BP+%$y2]
  SUB  BX,  DX
  INC  BX                    ; BX = vyska

  MOV  DX,  GS               ; DX = delka

@cyklus2:
  MOV  CX,  FS               ; CX = pocet MOVSD cyklu

@cyklus1:
  MOVSD
  LOOP @cyklus1
  MOV  CX,  BX
  SUB  DI,  DX
  ADD  DI,  320
  SUB  SI,  DX
  ADD  SI,  320
  DEC  BX
  LOOP @cyklus2
  RET

@kresli1:
  XOR  EDI, EDI
  MOV  BX,  [BP+%$y1]
  MOV  AX,  320
  MUL  BX                    ; AX := y1*320
  MOV  CX,  [BP+%$x1]
  ADD  AX,  CX               ; AX := y1*320+x1
  MOV  DI,  AX               ; ES:DI := offset

  XOR  ESI, ESI
  MOV  BX,  [BP+%$y2]
  MOV  AX,  320
  MUL  BX                    ; AX := y2*320
  MOV  CX,  [BP+%$x2]
  ADD  AX,  CX               ; AX := y2*320+x2
  MOV  SI,  AX               ; DS:SI := offset

  XOR  AX,  AX
  INC  AX
  MOV  BX,  GS
  CMP  BX,  AX
  JE   @mensi1

  MOV  AX,  GS               ; + delka
  ADD  DI,  AX
  MOV  AX,  GS               ; + delka
  ADD  SI,  AX

@mensi1:
  MOV  AX,  FS
  ADD  DI,  AX
  MOV  AX,  FS
  ADD  SI,  AX

  MOV  BX,  [BP+%$y3]
  MOV  DX,  [BP+%$y2]
  SUB  BX,  DX
  INC  BX                    ; BX = vyska

  MOV  CX,  BX               ; CX = pocet cyklu
@cyklus3:
  MOVSB
  DEC  DI
  ADD  DI,  320
  DEC  SI
  ADD  SI,  320
  LOOP @cyklus3

  RET

@start:
  MOV  AX,  [BP+%$BufferTo]
  MOV  ES,  AX               ; ES := segment BufferTo

  MOV  AX,  [BP+%$BufferFrom]
  MOV  DS,  AX               ; DS := segment BufferFrom

  MOV  AX,  [BP+%$x3]
  MOV  CX,  [BP+%$x2]
  SUB  AX,  CX
  INC  AX                    ; AX = delka
  MOV  BX,  AX               ; BX = delka

  SHR  BX,  2
  MOV  FS,  BX               ; FS = pocet cyklu MOVSD

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
  POP  DS

endproc