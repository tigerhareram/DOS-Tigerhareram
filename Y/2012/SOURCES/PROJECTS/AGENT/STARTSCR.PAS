Procedure ShowStartScreen;
Var x,y,xa: Word;
    I: Byte;
Begin
  ClearPage(Buffer[3]);

  x:=45; y:=50; xa:=160;
  For I:=0 to 4 do
  Begin
    WriteBlok(x,y,xa,0,xa+31,55,Buffer[1],Buffer[3]);
    Inc(xa,32);
    Inc(x,50);
  End;

  WriteText(Buffer[2],160,0,5,5,1,2,2,'rekord=',Buffer[3]);
  WriteNumber(Buffer[2],160,15,5,5,1,45,2,HiScore,Buffer[3]);
  Ramecek(0,0,319,199,ColorRed,Buffer[3]);
  Ramecek(0,150,319,185,ColorRed,Buffer[3]);
  WriteText(Buffer[2],160,0,5,5,5,10,155,'ijkl=pohyb',Buffer[3]);
  WriteText(Buffer[2],160,0,5,5,5,10,165,'a=skok s=box d=kop e=strela',Buffer[3]);
  WriteText(Buffer[2],160,0,5,5,5,10,175,'q=tabulka w=fps',Buffer[3]);

  If Fps2s=True then WriteText(Buffer[2],160,0,5,5,5,102,190,'press enter',Buffer[3])
                else Blok(102,190,218,194,ColorBlack,Buffer[3]);

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure StartScreen;
Var Ending: Boolean;
Begin
  Ending:=False;
  Repeat
    ShowStartScreen;

{Enter}    If Key[28]=True then
           Begin
             While Key[28]=True do Begin End;
             PlaySound(10);
             MainGame;
           End;

{Esc}      If Key[1]=True then Ending:=True;

  Until Ending=True;
End;