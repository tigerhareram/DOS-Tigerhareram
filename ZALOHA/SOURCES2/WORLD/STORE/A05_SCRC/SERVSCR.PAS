Procedure ServerScreen;
Var i: Byte;
Begin
  GoToXY(1,1);   Write('Adresa serveru:  ');
                 For i:=0 to 5 do Write(recNode[i],'.');
                 WriteLn;

  GoToXY(46,1);  Write('S.E.R.V.E.R');
  GoToXY(71,1);  Write('Esc=Exit');

  GoToXY(1,2);   WriteLN('-------------------------------------------------------------------------------');
  GoToXY(1,3);   WriteLN('Ocekavam pakety ... ');
  GoToXY(1,4);   WriteLN('-------------------------------------------------------------------------------');
End;
