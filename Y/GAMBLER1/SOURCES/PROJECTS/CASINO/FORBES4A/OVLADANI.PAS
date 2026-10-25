Procedure OvladaniScreen;
Begin
  ClearPage(Buffer[3]);

  Ramecek(0,0,319,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,268,5,'esc=exit',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,18,'do hry = enter',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,28,'konec programu = f10',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,38,'vhodit minci = klavesa od 1 do 6',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,48,'vsunout bankovku = klavesa 7 az 0',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,68,'vybrat kasu = q nebo dolu',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,84,'start = s',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,94,'auto start = a',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,104,'zmenit sazku = v nebo enter',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,114,'prepnout win/gamble = w nebo doleva nebo doprava',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,124,'prevest multiwin do creditu = drzet t nebo drzet d',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,142,'situace vyhry v dolni hre',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,152,'prevest vyhru do multiwinu = m nebo mezernik',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,162,'risk hlava = h',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,172,'risk orel = o',Buffer[3]);

  WaitRetrace;
  HideMouse;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
End;


Procedure Ovladani;
Var Ending: Boolean;
Begin
  Ending:=False;
  Repeat
    OvladaniScreen;
    Wait(DatRec.fpsProdleva);

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
      End;
  Until Ending=True;
End;