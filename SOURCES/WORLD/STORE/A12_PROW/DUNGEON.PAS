Procedure Dungeon;
Var
    Ending: Boolean;
    i: Byte;

Begin
  Ending:=False;
  SVGA_ResetPages;
  SVGA_TogglePaging;

  LoadGRAFile('PLANET01\data01a.gra',0,1);
  LoadMAPFile('PLANET01\level01.map',0);

  Repeat
    SVGA_ClearPage(ColX[0]);

{   Map_WriteSVGAComplet(Buffer[3]); }

    SVGA_Rectangle(0,400,639,479,ColX[15]);
    Text_OutText(5,403,'Dungeon Interface',Buffer[0],SVGA);

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

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           Ending:=True;                      {Esc MainMenu}
         End;

  Until Ending=True;
  SVGA_TogglePaging;
End;