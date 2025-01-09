Program IPX_Client;
Uses CRT,DOS,
     x01_Lite, x02_Lite, x03_Lite, x04_Lite, x05_Lite, x06_Lite, x07_Lite, x08_Lite;

Var
  IPXTransmit: Transmit;

  recNode_Backup: nodeaddr;
  SendBajt: Byte; {testovaci bajt komunikace}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  {$I D:\SOURCES\WORLD\STORE\A15_SERV\process.pas}
  {$I D:\SOURCES\WORLD\STORE\A15_SERV\main.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  If IPXgetParams=True then
  Begin
    PowerOn; VGA_Done;
    InitSend;
    Main;
    DoneSend;
    PowerOff;
  End;
End.