Procedure Zvuky;
Var EndZvuky: Boolean;
    i:Byte;
Begin

  EndZvuky:=False;

Repeat
    SVGA_ClearPage(ColX[0]);
    SVGA_Rectangle(0,0,639,399,ColX[15]);

    Text_OutText(40,20,'music432.waw',Buffer[0],SVGA);
    Text_OutText(40,32,'asmr.waw ',Buffer[0],SVGA);
    Text_OutText(40,44,'blaster1.waw ',Buffer[0],SVGA);
    Text_OutText(40,56,'blaster2.waw ',Buffer[0],SVGA);
    Text_OutText(40,68,'blaster3.waw ',Buffer[0],SVGA);
    Text_OutText(40,80,'wakeup1.waw ',Buffer[0],SVGA);
    Text_OutText(40,92,'wakeup2.waw ',Buffer[0],SVGA);
    Text_OutText(40,104,'wake-up.waw ',Buffer[0],SVGA);
    Text_OutText(40,116,'back ..',Buffer[0],SVGA);
{Kur}  Text_OutText(20-15,20+12*MainmenuSel,'>>',Buffer[0],SVGA);

   For i := 0 to 7 do
   Begin
     If Hraje[i]=True then Text_OutText(20,20+12*i,'on',Buffer[0],SVGA)
                      else Text_OutText(20,20+12*i,'off',Buffer[0],SVGA);
   End;


    SVGA_Rectangle(0,400,639,479,ColX[15]);
    Text_OutText(5,403,'Zvuky Sound Blaster 16',Buffer[0],SVGA);

    SVGA_WaitRetrace;
    SVGA_FlipPage;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

{Up}     If ((Key[72]=1) or (Key[23]=1)) then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If Key[23]=1 then Kbd_RPush(23);
           If MainMenuSel>0 then Dec(MainMenuSel);
         End;

{Down}   If ((Key[80]=1) or (Key[37]=1)) then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If Key[37]=1 then Kbd_RPush(37);
           If MainMenuSel<MainMenuMax then Inc(MainMenuSel);
         End;

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);

           If MainMenuSel<MainMenuMax then
           Begin
             If Hraje[MainMenuSel]=False
             then Begin
                    Hraje[MainMenuSel]:=True;
                    StartSound(ZvukRaw[MainMenuSel],MainMenuSel,True);
                  End
             else Begin
                    Hraje[MainMenuSel]:=False;
                    StopSound(MainMenuSel);
                  End;
           End;

           If MainMenuSel=MainMenuMax then {press back ..}
           Begin
             EndZvuky:=True;
           End;
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           EndZvuky:=True;                      {Esc MainMenu}
         End;


Until EndZvuky=True;
End;