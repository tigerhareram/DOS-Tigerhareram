Procedure WriteSymbol(x,y:Word; Symbol:Byte; Color:Boolean; Up,Down:Byte);
Var A,B: Word;
Begin
  Case Symbol of
    1: Begin
         If Color=True then Begin
                              A:=32+Up;
                              B:=63-Down;
                              If B>A then
                              WriteBlok(x,y,40,A,79,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=32+Up;
                              B:=63-Down;
                              If B>A then
                              WriteBlok(x,y,0,A,39,B,Buffer[1],Buffer[3]);
                            End;
       End;
    2: Begin
         If Color=True then Begin
                              A:=64+Up;
                              B:=95-Down;
                              If B>A then
                              WriteBlok(x,y,40,A,79,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=64+Up;
                              B:=95-Down;
                              If B>A then
                              WriteBlok(x,y,0,A,39,B,Buffer[1],Buffer[3]);
                            End;
       End;
    3: Begin
         If Color=True then Begin
                              A:=96+Up;
                              B:=127-Down;
                              If B>A then
                              WriteBlok(x,y,40,A,79,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=96+Up;
                              B:=127-Down;
                              If B>A then
                              WriteBlok(x,y,0,A,39,B,Buffer[1],Buffer[3]);
                            End;
       End;
    4: Begin
         If Color=True then Begin
                              A:=128+Up;
                              B:=159-Down;
                              If B>A then
                              WriteBlok(x,y,40,A,79,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=128+Up;
                              B:=159-Down;
                              If B>A then
                              WriteBlok(x,y,0,A,39,B,Buffer[1],Buffer[3]);
                            End;
       End;
    5: Begin
         If Color=True then Begin
                              A:=160+Up;
                              B:=191-Down;
                              If B>A then
                              WriteBlok(x,y,40,A,79,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=160+Up;
                              B:=191-Down;
                              If B>A then
                              WriteBlok(x,y,0,A,39,B,Buffer[1],Buffer[3]);
                            End;
       End;
    6: Begin
         If Color=True then Begin
                              A:=32+Up;
                              B:=63-Down;
                              If B>A then
                              WriteBlok(x,y,120,A,159,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=32+Up;
                              B:=63-Down;
                              If B>A then
                              WriteBlok(x,y,80,A,119,B,Buffer[1],Buffer[3]);
                            End;
       End;
    7: Begin
         If Color=True then Begin
                              A:=64+Up;
                              B:=95-Down;
                              If B>A then
                              WriteBlok(x,y,120,A,159,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=64+Up;
                              B:=95-Down;
                              If B>A then
                              WriteBlok(x,y,80,A,119,B,Buffer[1],Buffer[3]);
                            End;
       End;
    8: Begin
         If Color=True then Begin
                              A:=96+Up;
                              B:=127-Down;
                              If B>A then
                              WriteBlok(x,y,120,A,159,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=96+Up;
                              B:=127-Down;
                              If B>A then
                              WriteBlok(x,y,80,A,119,B,Buffer[1],Buffer[3]);
                            End;
       End;
    9: Begin
         If Color=True then Begin
                              A:=128+Up;
                              B:=159-Down;
                              If B>A then
                              WriteBlok(x,y,120,A,159,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=128+Up;
                              B:=159-Down;
                              If B>A then
                              WriteBlok(x,y,80,A,119,B,Buffer[1],Buffer[3]);
                            End;
       End;
    0: Begin
         If Color=True then Begin
                              A:=160+Up;
                              B:=191-Down;
                              If B>A then
                              WriteBlok(x,y,120,A,159,B,Buffer[1],Buffer[3])
                            End
                       else Begin
                              A:=160+Up;
                              B:=191-Down;
                              If B>A then
                              WriteBlok(x,y,80,A,119,B,Buffer[1],Buffer[3]);
                            End;
       End;
  End; {Case End}
End;