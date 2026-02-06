Procedure WriteParta;
Begin
  If Parta.Pesky=True then
  Begin
    Case Parta.Smer of
      0: Begin
           If Parta.VLese=False then
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,0,Parta.Vudce*16,15,Parta.Vudce*16+15,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,16,Parta.Vudce*16,31,Parta.Vudce*16+15,Buffer[1],Buffer[3])
           End Else
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,0,Parta.Vudce*16,15,Parta.Vudce*16+7,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,16,Parta.Vudce*16,31,Parta.Vudce*16+7,Buffer[1],Buffer[3])
           End;
         End;
      1: Begin
           If Parta.VLese=False then
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,32,Parta.Vudce*16,47,Parta.Vudce*16+15,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,48,Parta.Vudce*16,63,Parta.Vudce*16+15,Buffer[1],Buffer[3])
           End Else
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,32,Parta.Vudce*16,47,Parta.Vudce*16+7,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,48,Parta.Vudce*16,63,Parta.Vudce*16+7,Buffer[1],Buffer[3])
           End;
         End;
      2: Begin
           If Parta.VLese=False then
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,64,Parta.Vudce*16,79,Parta.Vudce*16+15,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,80,Parta.Vudce*16,95,Parta.Vudce*16+15,Buffer[1],Buffer[3])
           End Else
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,64,Parta.Vudce*16,79,Parta.Vudce*16+7,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,80,Parta.Vudce*16,95,Parta.Vudce*16+7,Buffer[1],Buffer[3])
           End;
         End;
      3: Begin
           If Parta.VLese=False then
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,96,Parta.Vudce*16,111,Parta.Vudce*16+15,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,112,Parta.Vudce*16,127,Parta.Vudce*16+15,Buffer[1],Buffer[3])
           End Else
           Begin
             If Parta.Frame=0 then WriteSprite(152,104,96,Parta.Vudce*16,111,Parta.Vudce*16+7,Buffer[1],Buffer[3])
                              else WriteSprite(152,104,112,Parta.Vudce*16,127,Parta.Vudce*16+7,Buffer[1],Buffer[3])
           End;
         End;
    End; {Case End}
  End;

  If Parta.VLodi1=True then
  Begin
    Case Parta.Smer of
      0: WriteSprite(152,104,0,96,15,111,Buffer[1],Buffer[3]);
      1: WriteSprite(152,104,32,96,47,111,Buffer[1],Buffer[3]);
      2: WriteSprite(152,104,64,96,79,111,Buffer[1],Buffer[3]);
      3: WriteSprite(152,104,96,96,111,111,Buffer[1],Buffer[3]);
    End; {Case End}
  End;

  If Parta.VLodi2=True then
  Begin
    WriteSprite(152,104,128,112,143,127,Buffer[1],Buffer[3]); {st¡n pod lod¡}
    Case Parta.Smer of
      0: Begin
           If Parta.Frame=0 then WriteSprite(152,104-Lod2.Vyskomer,0,112,15,127,Buffer[1],Buffer[3])
                            else WriteSprite(152,104-Lod2.Vyskomer,16,112,31,127,Buffer[1],Buffer[3])
         End;
      1: Begin
           If Parta.Frame=0 then WriteSprite(152,104-Lod2.Vyskomer,32,112,47,127,Buffer[1],Buffer[3])
                            else WriteSprite(152,104-Lod2.Vyskomer,48,112,63,127,Buffer[1],Buffer[3])
         End;
      2: Begin
           If Parta.Frame=0 then WriteSprite(152,104-Lod2.Vyskomer,64,112,79,127,Buffer[1],Buffer[3])
                            else WriteSprite(152,104-Lod2.Vyskomer,80,112,95,127,Buffer[1],Buffer[3])
         End;
      3: Begin
           If Parta.Frame=0 then WriteSprite(152,104-Lod2.Vyskomer,96,112,111,127,Buffer[1],Buffer[3])
                            else WriteSprite(152,104-Lod2.Vyskomer,112,112,127,127,Buffer[1],Buffer[3])
         End;
    End; {Case End}
  End;

End;