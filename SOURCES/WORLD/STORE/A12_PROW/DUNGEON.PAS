Procedure Dungeon;
Var
    Ending: Boolean;
    i: Byte;

Begin
  Ending:=False;

  SVGA_TogglePaging;
  Repeat

    SVGA_ClearPage(ColX[0]);
    SVGA_Rectangle(0,0,639,479,ColX[15]);
    SVGA_Rectangle(0,0,639,15,ColX[15]);
    Text_OutText(5,3,'Ovladani: Sipky,Enter,Esc, IJKL+ASQW',Buffer[0],SVGA);
    Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
    Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);


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