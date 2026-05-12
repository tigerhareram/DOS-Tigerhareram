Procedure Init;
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

  setrgbpalette(ColX[0],0,0,0);    {Palette Color 0}
  setrgbpalette(ColX[1],0,0,255);  {Palette Color 1 : R=24, G=40, B=16}
  setrgbpalette(ColX[2],255,0,0);

  loadfont('fonts\descent.chs',3);
End;