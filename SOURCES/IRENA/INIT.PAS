Procedure Init;
Var N: Byte;
Begin
  ColX[0]:=0;
  ColX[1]:=1;
  ColX[2]:=2;
  ColX[3]:=3;
  ColX[4]:=4;
  ColX[5]:=5;
  ColX[6]:=6;
  ColX[7]:=7;
  ColX[8]:=8;
  ColX[9]:=9;
  ColX[10]:=10;
  ColX[11]:=11;
  ColX[12]:=12;
  ColX[13]:=13;
  ColX[14]:=14;
  ColX[15]:=15;

  setcolor(ColX[1]); {set drawing color , texts & lines}

  setrgbpalette(ColX[0],0,0,0);    {Palette Color 0 Black}
  setrgbpalette(ColX[1],0,63,0);   {Palette Color 1 Green}
  setrgbpalette(ColX[2],50,20,35); {Palette Color 2 Button selected}
  setrgbpalette(ColX[3],40,35,45); {Palette Color 3 text page font color}

  loadfont('FONTS\sysfont2.chs',3);
  loadfont('FONTS\sys8x16.chs',4);

  Xsour:=0;
  Ysour:=0;
End;