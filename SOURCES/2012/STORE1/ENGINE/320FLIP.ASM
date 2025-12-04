[SECTION ._TEXT]
%define PASCAL
%include "C:\SOURCES\STORE1\MACROS\c16.mac"

proc FlipPage

%$BufferTo arg
%$BufferFrom arg

  PUSH DS
  XOR  EAX, EAX
  MOV  AX,  [BP+%$BufferTo]
  MOV  ES,  AX
  XOR  EDI, EDI
  MOV  AX,  [BP+%$BufferFrom]
  MOV  DS,  AX
  XOR  ESI, ESI

  MOV CX, 16000
@cyklus:
  MOVSD
  LOOP @cyklus
  POP DS

endproc