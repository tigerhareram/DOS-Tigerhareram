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

  setrgbpal(ColX[0],0,0,0);    {Palette Color 0}
  setrgbpal(ColX[1],24,40,16); {Palette Color 1 : R=24, G=40, B=16}

  loadfont('fonts\descent.chs',3);

  {image object [0..9] } {object alien 160x200 complete image}
  Image[0].ImgX:= 320; {from where we take source image on actual page}
  Image[0].ImgY:= 0;
  Image[0].ImgXsize:= 160; {size}
  Image[0].ImgYsize:= 200;
 {Image[0].ImgPointer;}

  {image object [0..9] } {object cosmon 160x200 complete image}
  Image[1].ImgX:= 480; {from where we take source image on actual page}
  Image[1].ImgY:= 0;
  Image[1].ImgXsize:= 160; {size}
  Image[1].ImgYsize:= 200;
 {Image[1].ImgPointer;}

End;