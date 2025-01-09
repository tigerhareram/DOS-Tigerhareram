Procedure ServerMain;
Begin
  ClrScr;
  ServerScreen;

  CisloKlienta:=0;
  PocetKlientu:=0;
  Repeat

    TestReceive(IPXTransmit);
    If IPXTransmit.Prvni=1 then ServerProcess; {Odpovedet na paket}

  Until Key[1]=1;

End;
