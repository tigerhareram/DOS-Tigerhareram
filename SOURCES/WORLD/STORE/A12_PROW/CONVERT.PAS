Procedure Convert;
Var EndConvert: Boolean;
    i:Byte;

Begin
  EndConvert:=False;

  If ParamCount>0 then LoadGRAFile(ParamStr(1),0,0);
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[2]);

  Repeat
    SVGA_ClearPage(ColX[0]);
    SVGA_Rectangle(0,0,639,399,ColX[15]);
    SVGA_Rectangle(0,0,639,15,ColX[15]);
    Text_OutText(5,3,'Ovladani: Sipky,Enter,Esc, IJKL+ASQW',Buffer[0],SVGA);
    Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
    Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

    SVGA_Rectangle(20,35,189,244,ColX[15]);
    SVGA_SprZ(25,40,0,0,159,199,1,Buffer[2]);

    SVGA_Rectangle(420,35,589,244,ColX[15]);
    SVGA_SprZ(425,40,160,0,319,199,1,Buffer[2]);

    SVGA_Rectangle(0,400,639,479,ColX[15]);
    Text_OutText(5,403,'GRA>BMP converter',Buffer[0],SVGA);
    Text_OutText(5,423,'press F2 to convert',Buffer[0],SVGA);
    Text_OutText(325,403,'press Enter to toggle image on Text page visibility',Buffer[0],SVGA);
    If Scan_Toggle=True then Text_OutText(325,423,'scan on text page enabled',Buffer[0],SVGA)
                        else Text_OutText(325,423,'scan on text page disabled',Buffer[0],SVGA);
    Text_OutText(325,443,'check visibility image on text page',Buffer[0],SVGA);
    Text_OutText(325,463,'work only with file scan.bmp',Buffer[0],SVGA);

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

{F2}     If ((Key[60]=1) or (Key[30]=1)) then
         Begin
           If Key[60]=1 then Kbd_RPush(60);
           If Key[30]=1 then Kbd_RPush(30);
           If ParamCount>0 then SaveBMPFile('convert.bmp',0);
         End;

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);
           Scan_ToggleProc;
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           EndConvert:=True;                      {Esc MainMenu}
         End;

  Until EndConvert=True;

End;