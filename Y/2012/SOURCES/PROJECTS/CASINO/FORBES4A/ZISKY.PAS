Procedure Zisky(X,Y,I: Word);
Var A,B,C: LongInt;
Begin
 Case I of
 255:
  Begin
    A:=DatRec2.Pub.Vklady;
    B:=DatRec2.Pub.Vyplaceno;
    If DatRec2.Pub.Vklady>DatRec2.Pub.Vyplaceno
    then Begin
           C:=A-B;
           WriteText(Buffer[1],160,0,5,5,1,X,Y,'-',Buffer[3]);
           WriteNumber(Buffer[1],160,15,5,5,1,X+6,Y,C,Buffer[3]);
         End;
    If DatRec2.Pub.Vklady<DatRec2.Pub.Vyplaceno
    then Begin
           C:=B-A;
           WriteText(Buffer[1],160,0,5,5,1,X,Y,'+',Buffer[3]);
           WriteNumber(Buffer[1],160,15,5,5,1,X+6,Y,C,Buffer[3]);
         End;
    If DatRec2.Pub.Vklady=DatRec2.Pub.Vyplaceno
    then WriteNumber(Buffer[1],160,15,5,5,1,X,Y,0,Buffer[3]);
  End;
 0..24:
  Begin
    A:=DatRec2.Vklad[I];
    B:=DatRec2.Vyplaceno[I];
    If DatRec2.Vklad[I]>DatRec2.Vyplaceno[I]
    then Begin
           C:=A-B;
           WriteText(Buffer[1],160,0,5,5,1,X,Y,'-',Buffer[3]);
           WriteNumber(Buffer[1],160,15,5,5,1,X+6,Y,C,Buffer[3]);
         End;
    If DatRec2.Vklad[I]<DatRec2.Vyplaceno[I]
    then Begin
           C:=B-A;
           WriteText(Buffer[1],160,0,5,5,1,X,Y,'+',Buffer[3]);
           WriteNumber(Buffer[1],160,15,5,5,1,X+6,Y,C,Buffer[3]);
         End;
    If ((I=0) and (DatRec2.Vklad[I]=DatRec2.Vyplaceno[I]))
    then WriteNumber(Buffer[1],160,15,5,5,1,X,Y,0,Buffer[3]);
  End;
 End; {Case End}
End;