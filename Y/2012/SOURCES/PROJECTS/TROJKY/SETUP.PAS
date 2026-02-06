Procedure SetupScreen;
Begin
  ClearPage(Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,270,5,'esc=exit',Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,10,5,'l = rychlost hry =',Buffer[3]);
  WriteNumber(Buffer[1],0,195,5,5,1,120,5,51-fps.prodleva,Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,10,15,'b = sound blaster =',Buffer[3]);
  If SB=True then WriteText(Buffer[1],0,180,5,5,1,127,15,'povoleno',Buffer[3])
             else WriteText(Buffer[1],0,180,5,5,1,127,15,'zakazano',Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure Setup;
Var Ending: Boolean;
Begin
  Ending:=False;
  Repeat
    SetupScreen;
    Wait(fps.prodleva);

{L}   If Key[38]=True then
      Begin
        While Key[38]=True do WaitButton(38,20);
        If fps.prodleva>1 then Dec(fps.prodleva)
                          else fps.prodleva:=50;
      End;

{B}   If Key[48]=True then
      Begin
        While Key[48]=True do Begin End;
        If SB=True then SB:=False
                   else SB:=True;
      End;

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
      End;
  Until Ending=True;
  HiScoreSaveLoad(True); {SAVE}
End;