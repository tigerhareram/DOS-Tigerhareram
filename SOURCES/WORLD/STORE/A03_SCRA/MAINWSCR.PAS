Procedure MainWorldScreen;
Var X,Y,I: Byte;
Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_WaitRetrace;
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

  If MainMenu=0 then
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Hit100A',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Hit100B',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Hit100C',Buffer[0],SVGA);
    I:=3;  Text_OutText(20,30+15*I,'Hit100D',Buffer[0],SVGA);
    I:=4;  Text_OutText(20,30+15*I,'Hit50',Buffer[0],SVGA);
    I:=5;  Text_OutText(20,30+15*I,'Hit25A',Buffer[0],SVGA);
    I:=6;  Text_OutText(20,30+15*I,'Hit25B',Buffer[0],SVGA);
    I:=7;  Text_OutText(20,30+15*I,'Hit15',Buffer[0],SVGA);
    I:=8;  Text_OutText(20,30+15*I,'Exit',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// MENU //',Buffer[0],SVGA);

    {World}
    SVGA_Rectangle(285,30,624,349,ColX[15]);
    For Y:=0 to 99 do
    For X:=0 to 159 do SVGA_BarZ(295+X*2,40+Y*3,295+1+X*2,40+2+Y*3,mem[Buffer[1]:Y*320+X]);
    {Rambo}
    SVGA_Rectangle(524,349,624,419,ColX[15]);
    SVGA_SprZ(534,359,0,100,79,149,1,Buffer[1]);
  End;

  If MainMenu=1 then
  Begin
  End;

  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;
