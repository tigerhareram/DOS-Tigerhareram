Procedure WriteSymbolLight(x,y:Word; Symbol:Byte; Color:Byte; Light:Byte; Up,Down:Byte;BufferTo:Word);
Var A,B: Word;
Begin
  If DatRec.Svetla=True then
  Begin
    A:=0+Up;
    B:=23-Down;
    If B>A then WriteBlok(x,y,Light*32,A,Light*32+31,B,Buffer[2],BufferTo);

    A:=104+(Color*24)+Up;
    B:=127+(Color*24)-Down;
    If B>A then
    Begin
      If Symbol>0 then WriteSprite(x,y,(Symbol-1)*32,A,(Symbol-1)*32+31,B,Buffer[2],BufferTo)
                  else WriteSprite(x,y,9*32,A,9*32+31,B,Buffer[2],BufferTo)
    End;
  End else
  Begin
    A:=104+(Color*24)+Up;
    B:=127+(Color*24)-Down;
    If B>A then
    Begin
      If Symbol>0 then WriteBlok(x,y,(Symbol-1)*32,A,(Symbol-1)*32+31,B,Buffer[2],BufferTo)
                  else WriteBlok(x,y,9*32,A,9*32+31,B,Buffer[2],BufferTo)
    End;

  End;
End;


Procedure KresliValce(SymbolLight,Svetlo1,Svetlo2,Svetlo3:Byte;BufferTo:Word);
Var I: Byte;
Begin
  Blok(0,125,111,199,ColorUnknown,Buffer[0]);

  Ramecek(4,126,37,199,ColorRedDark,Buffer[0]);
  Ramecek(39,126,72,199,ColorRedDark,Buffer[0]);
  Ramecek(74,126,107,199,ColorRedDark,Buffer[0]);

  WriteSymbolLight(5 ,127,Valec[0].Symbol[0],SymbolLight,Svetlo1,24-Valec[0].Scroll,0,Buffer[0]);
  WriteSymbolLight(40,127,Valec[1].Symbol[0],SymbolLight,Svetlo2,24-Valec[1].Scroll,0,Buffer[0]);
  WriteSymbolLight(75,127,Valec[2].Symbol[0],SymbolLight,Svetlo3,24-Valec[2].Scroll,0,Buffer[0]);

  WriteSymbolLight(5 ,127+Valec[0].Scroll,Valec[0].Symbol[1],SymbolLight,Svetlo1,0,0,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll,Valec[1].Symbol[1],SymbolLight,Svetlo2,0,0,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll,Valec[2].Symbol[1],SymbolLight,Svetlo3,0,0,Buffer[0]);

  WriteSymbolLight(5 ,127+Valec[0].Scroll+24,Valec[0].Symbol[2],SymbolLight,Svetlo1,0,0,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll+24,Valec[1].Symbol[2],SymbolLight,Svetlo2,0,0,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll+24,Valec[2].Symbol[2],SymbolLight,Svetlo3,0,0,Buffer[0]);

  WriteSymbolLight(5 ,127+Valec[0].Scroll+48,Valec[0].Symbol[3],SymbolLight,Svetlo1,0,Valec[0].Scroll,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll+48,Valec[1].Symbol[3],SymbolLight,Svetlo2,0,Valec[1].Scroll,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll+48,Valec[2].Symbol[3],SymbolLight,Svetlo3,0,Valec[2].Scroll,Buffer[0]);

  For I:=0 to 1 do
  Begin
    If Linie[I].Indicator[1]=1 then Blok(I*109,126,I*109+2,128,ColorWhite,Buffer[0])
                               else Blok(I*109,126,I*109+2,128,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[2]=1 then Blok(I*109,137,I*109+2,139,ColorWhite,Buffer[0])
                               else Blok(I*109,137,I*109+2,139,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[3]=1 then Blok(I*109,161,I*109+2,163,ColorWhite,Buffer[0])
                               else Blok(I*109,161,I*109+2,163,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[4]=1 then Blok(I*109,185,I*109+2,187,ColorWhite,Buffer[0])
                               else Blok(I*109,185,I*109+2,187,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[5]=1 then Blok(I*109,197,I*109+2,199,ColorWhite,Buffer[0])
                               else Blok(I*109,197,I*109+2,199,ColorRedDark,Buffer[0]);
  End;

  HideMouse;
  WriteBlok(103,46,0,125,111,199,Buffer[0],BufferTo);
  ShowMouse;
End;