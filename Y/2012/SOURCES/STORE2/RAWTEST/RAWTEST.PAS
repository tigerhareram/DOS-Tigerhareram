{Funguje pouze v real modu}

Program RAWtest;
Uses Lite;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitSB;
  InitTimer;
  InitRawBuffers;

  Wait(4096);
  LoadDefaultFont(160,0,40,Buffer[1]);
  If ParamStr(1)<>'' then
  Begin
    LoadRawFile(ParamStr(1),0,0);
    Blok(0,0,319,199,50,Buffer[4]);
    Ramecek(0,0,319,199,40,Buffer[4]);
    Repeat
      WriteText(Buffer[1],160,0,5,5,1,10,10,'exit = esc plus enter',Buffer[4]);
      WriteText(Buffer[1],160,0,5,5,1,10,20,'hraje raw',Buffer[4]);
      WriteText(Buffer[1],160,0,5,5,1,70,20,ParamStr(1),Buffer[4]);
      SBPlayRaw(0);
      Repeat Until Key[28]=True;
      While Key[28]=True do Begin End;
    Until Key[1]=True;
  End;

  ShutdownRawBuffers;
  ShutdownTimer;
  ShutdownSB;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End.