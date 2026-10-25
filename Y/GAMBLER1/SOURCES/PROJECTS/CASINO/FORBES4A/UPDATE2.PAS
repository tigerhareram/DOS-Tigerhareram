Procedure UpdateDuchod;
Begin
  HideMouse;
  Blok(264,31,319,39,ColorUnknown,Buffer[4]);
  OutNumber(264,33,DatRec2.Hotovost,False,Buffer[4]);
  If ((DatRec2.Hotovost>=0) and (DatRec2.Hotovost<10)) then OutText(272,32,'KŸ',Buffer[4]);
  If ((DatRec2.Hotovost>=10) and (DatRec2.Hotovost<100)) then OutText(278,32,'KŸ',Buffer[4]);
  If ((DatRec2.Hotovost>=100) and (DatRec2.Hotovost<1000)) then OutText(284,32,'KŸ',Buffer[4]);
  If ((DatRec2.Hotovost>=1000) and (DatRec2.Hotovost<10000)) then OutText(290,32,'KŸ',Buffer[4]);
  If ((DatRec2.Hotovost>=10000) and (DatRec2.Hotovost<100000)) then OutText(296,32,'KŸ',Buffer[4]);
  If ((DatRec2.Hotovost>=100000) and (DatRec2.Hotovost<9999999)) then OutText(307,32,'KŸ',Buffer[4]);
  ShowMouse;
End;