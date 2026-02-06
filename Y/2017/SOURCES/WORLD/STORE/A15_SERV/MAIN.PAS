Procedure Screen;
Var i: Byte;
Begin
  GoToXY(1,1); Write('Adresa clienta:  ');
               For i:=0 to 5 do Write(fromNode[i],'.');
               WriteLn;
  GoToXY(46,1); WriteLn('C.L.I.E.N.T');
  GoToXY(71,1); WriteLn('Esc=Exit');

  GoToXY(1,2); WriteLN('-------------------------------------------------------------------------------');
  GoToXY(1,3); WriteLN('Stisknete Enter pro ping se serverem ... ');
  GoToXY(1,4); WriteLN('-------------------------------------------------------------------------------');
End;


Procedure Main;
Var SendBajt: Byte;
Begin
  ClrScr;
  Screen;

  Repeat

    Processing;

  Until Key[1]=1;

End;
