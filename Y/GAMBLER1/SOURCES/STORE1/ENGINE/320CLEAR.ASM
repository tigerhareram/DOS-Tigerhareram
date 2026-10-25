[SECTION ._TEXT]
%define PASCAL
%include "C:\SOURCES\STORE1\MACROS\c16.mac"

proc ClearPage

%$Buffer arg

  XOR  EAX, EAX
  MOV  AX,  [BP+%$Buffer]
  MOV  ES,  AX
  XOR  EDI, EDI
  XOR  EAX, EAX
  MOV  CX,  16000
@cyklus:
  STOSD
  LOOP  @cyklus

endproc