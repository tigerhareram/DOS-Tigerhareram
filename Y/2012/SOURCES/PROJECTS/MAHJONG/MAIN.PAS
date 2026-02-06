Procedure MainScreen;
Begin
  ClearPage(Buffer[3]);
  Ramecek(0,0,319,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,122,MainVolba,'x',Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,132,165,'new game',Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,132,175,'database',Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,132,185,'exit',Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure Main;
Var Ending: Boolean;
Begin
  Ending:=False;
  MainVolba:=165;
  Repeat
    MainScreen;
{Up}   If Key[72]=True then
       Begin
         While Key[72]=True do Begin End;
         If MainVolba>165 then Dec(MainVolba,10);
       End;

{Down} If Key[80]=True then
       Begin
         While Key[80]=True do Begin End;
         If MainVolba<185 then Inc(MainVolba,10);
       End;

{Enter} If Key[28]=True then
        Begin
          While Key[28]=True do Begin End;
          Case MainVolba of
            165: NewGame;
            175: Database;
            185: Ending:=True;
          End; {Case End}
        End;

{Esc}  If Key[1]=True then Ending:=True;
  Until Ending=True;
End;