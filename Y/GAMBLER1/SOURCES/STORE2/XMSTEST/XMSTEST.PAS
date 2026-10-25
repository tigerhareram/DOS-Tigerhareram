{Funguje pouze v real modu}

Program XMStest;
Uses Lite;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  Init320x200;
  InitBuffers;
  InitKeyboard;
  InitTimer;
  LoadDefaultFont(160,0,40,Buffer[1]);

  Blok(0,0,319,199,50,Buffer[4]);
  Ramecek(0,0,319,199,40,Buffer[4]);
  Repeat
    WriteText(Buffer[1],160,0,5,5,1,10,10,'xms celkem',Buffer[4]);
    WriteNumber(Buffer[1],160,15,5,5,1,75,10,xmsCelkemPotreba,Buffer[4]);
    WriteText(Buffer[1],160,0,5,5,1,10,20,'xms blok',Buffer[4]);
    WriteNumber(Buffer[1],160,15,5,5,1,75,20,xmsBlokPotreba,Buffer[4]);
  Until Key[1]=True;

  ShutdownTimer;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End.