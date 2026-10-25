Procedure PlusBankovka(Cislo: Byte);
Var I: Byte;
Begin
  For I:=0 to 38 do
  Begin
    Blok(280,44,319,75,ColorUnknown,Buffer[4]);

    {INSERT MONEY MOUSE 50}
    Blok(285,43,315,59,ColorBlack,Buffer[4]);
    Ramecek(285,43,315,59,ColorGreen,Buffer[4]);
    WriteNumber(Buffer[1],160,55,5,5,1,295,48,50,Buffer[4]);

    {INSERT MONEY MOUSE 500}
    Blok(285,62,315,78,ColorBlack,Buffer[4]);
    Ramecek(285,62,315,78,ColorGreen,Buffer[4]);
    WriteNumber(Buffer[1],160,55,5,5,1,292,67,500,Buffer[4]);

    Case Cislo of
{100}  7: WriteSprite(280,44,240+I,168,279,199,Buffer[1],Buffer[4]);
{200}  8: WriteSprite(280,44,280+I,168,319,199,Buffer[1],Buffer[4]);
{500}  9: WriteSprite(280,44,200+I,168,239,199,Buffer[1],Buffer[4]);
{1000} 0: WriteSprite(280,44,160+I,168,199,199,Buffer[1],Buffer[4]);
    End; {Case End}
    Wait(DatRec.fpsProdleva);
  End;
End;