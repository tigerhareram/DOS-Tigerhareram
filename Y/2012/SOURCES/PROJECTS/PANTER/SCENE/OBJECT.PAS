Procedure WriteObject(X,Y:Word; Typ: Char; Xa,Ya,Smer,Frame: Byte; BufferFrom: Word);
Begin
  If ((Mapa.Xview<=4799) and (Mapa.Yview<=3007)) then
  Begin

    {na obrazovce v rozsahu}
    If (((X>=Mapa.Xview) and (X<Mapa.Xview+304)) and
        ((Y>=Mapa.Yview) and (Y<Mapa.Yview+184))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15,Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79,Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+16,Ya,Xa+31,Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+32,Ya,Xa+47,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+48,Ya,Xa+63,Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+80,Ya,Xa+95,Ya+15,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+112,Ya,Xa+127,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {levy okraj}
    If (((X>=Mapa.Xview-15) and (X<Mapa.Xview)) and
        ((Y>=Mapa.Yview) and (Y<Mapa.Yview+184))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(0,Y-Mapa.Yview+8,Xa+Mapa.Xview-X,Ya,Xa+15,Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(0,Y-Mapa.Yview+8,Xa+64+Mapa.Xview-X,Ya,Xa+79,Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(0,Y-Mapa.Yview+8,Xa+96+Mapa.Xview-X,Ya,Xa+111,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+Mapa.Xview-X,Ya,Xa+15,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+16+Mapa.Xview-X,Ya,Xa+31,Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+32+Mapa.Xview-X,Ya,Xa+47,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+48+Mapa.Xview-X,Ya,Xa+63,Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+64+Mapa.Xview-X,Ya,Xa+79,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+64+Mapa.Xview-X,Ya,Xa+80,Ya+95,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+96+Mapa.Xview-X,Ya,Xa+111,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+112+Mapa.Xview-X,Ya,Xa+127,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {pravy okraj}
    If (((X>=Mapa.Xview+304) and (X<Mapa.Xview+320)) and
        ((Y>=Mapa.Yview) and (Y<Mapa.Yview+184))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+16,Ya,Xa+31-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+32,Ya,Xa+47-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+48,Ya,Xa+63-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+80,Ya,Xa+95-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+112,Ya,Xa+127-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {horni okraj}
    If (((X>=Mapa.Xview) and (X<Mapa.Xview+304)) and
        ((Y>=Mapa.Yview-15) and (Y<Mapa.Yview))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,8,Xa,Ya+Mapa.Yview-Y,Xa+15,Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,8,Xa+64,Ya+Mapa.Yview-Y,Xa+79,Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,8,Xa+96,Ya+Mapa.Yview-Y,Xa+111,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa,Ya+Mapa.Yview-Y,Xa+15,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+16,Ya+Mapa.Yview-Y,Xa+31,Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+32,Ya+Mapa.Yview-Y,Xa+47,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+48,Ya+Mapa.Yview-Y,Xa+63,Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+64,Ya+Mapa.Yview-Y,Xa+79,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+80,Ya+Mapa.Yview-Y,Xa+95,Ya+15,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+96,Ya+Mapa.Yview-Y,Xa+111,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+112,Ya+Mapa.Yview-Y,Xa+127,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {dolni okraj}
    If (((X>=Mapa.Xview) and (X<Mapa.Xview+304)) and
        ((Y>=Mapa.Yview+176) and (Y<Mapa.Yview+192))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa,Ya,Xa+15,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+16,Ya,Xa+31,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+32,Ya,Xa+47,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+48,Ya,Xa+63,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+64,Ya,Xa+79,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+80,Ya,Xa+95,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+96,Ya,Xa+111,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,Xa+112,Ya,Xa+127,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {levy horni roh}
    If (((X>=Mapa.Xview-15) and (X<Mapa.Xview)) and
        ((Y>=Mapa.Yview-15) and (Y<Mapa.Yview))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(0,8,Xa+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+15,Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(0,8,Xa+64+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+79,Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(0,8,Xa+96+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+111,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(0,8,Xa+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+15,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,8,Xa+16+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+31,Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(0,8,Xa+32+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+47,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,8,Xa+48+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+79,Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(0,8,Xa+64+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+79,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,8,Xa+80+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+95,Ya+15,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(0,8,Xa+96+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+111,Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(0,8,Xa+112+Mapa.Xview-X,Ya+Mapa.Yview-Y,Xa+127,Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {pravy horni roh}
    If (((X>=Mapa.Xview+304) and (X<Mapa.Xview+320)) and
        ((Y>=Mapa.Yview-15) and (Y<Mapa.Yview))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,8,Xa,Ya+Mapa.Yview-Y,Xa+15-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,8,Xa+64,Ya+Mapa.Yview-Y,Xa+79-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,8,Xa+96,Ya+Mapa.Yview-Y,Xa+111-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa,Ya+Mapa.Yview-Y,Xa+15-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+16,Ya+Mapa.Yview-Y,Xa+31-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+32,Ya+Mapa.Yview-Y,Xa+47-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+48,Ya+Mapa.Yview-Y,Xa+63-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+64,Ya+Mapa.Yview-Y,Xa+79-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+80,Ya+Mapa.Yview-Y,Xa+95-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,8,Xa+96,Ya+Mapa.Yview-Y,Xa+111-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,8,Xa+112,Ya+Mapa.Yview-Y,Xa+127-(X-Mapa.Xview-304),Ya+15,BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {levy dolni roh}
    If (((X>=Mapa.Xview-15) and (X<Mapa.Xview)) and
        ((Y>=Mapa.Yview+176) and (Y<Mapa.Yview+192))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(0,Y-Mapa.Yview+8,Xa+Mapa.Xview-X,Ya,Xa+15,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(0,Y-Mapa.Yview+8,Xa+64+Mapa.Xview-X,Ya,Xa+79,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: WriteSprite(0,Y-Mapa.Yview+8,Xa+96+Mapa.Xview-X,Ya,Xa+111,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+Mapa.Xview-X,Ya,Xa+15,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+16+Mapa.Xview-X,Ya,Xa+31,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+32+Mapa.Xview-X,Ya,Xa+47,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+48+Mapa.Xview-X,Ya,Xa+63,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+64+Mapa.Xview-X,Ya,Xa+79,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+80+Mapa.Xview-X,Ya,Xa+95,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(0,Y-Mapa.Yview+8,Xa+96+Mapa.Xview-X,Ya,Xa+111,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(0,Y-Mapa.Yview+8,Xa+112+Mapa.Xview-X,Ya,Xa+127,Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;

    {pravy dolni roh}
    If (((X>=Mapa.Xview+304) and (X<Mapa.Xview+320)) and
        ((Y>=Mapa.Yview+176) and (Y<Mapa.Yview+192))) then
    Begin
      Case Typ of
'A': Begin {Ctverec}
       WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
       Xa,Ya,Xa+15-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
     End;
'B': Begin {Lod}
      Case Smer of
        2: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
           Xa+64,Ya,Xa+79-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
           Xa+96,Ya,Xa+111-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
'C': Begin {NPC}
      Case Smer of
        0: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa,Ya,Xa+15-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+16,Ya,Xa+31-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        1: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+32,Ya,Xa+47-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+48,Ya,Xa+63-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        2: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+64,Ya,Xa+79-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+80,Ya,Xa+95-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
        3: If Frame=0
        then WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
             Xa+96,Ya,Xa+111-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3])
        else  WriteSprite(X-Mapa.Xview,Y-Mapa.Yview+8,
              Xa+112,Ya,Xa+127-(X-Mapa.Xview-304),Ya+15-(Y-Mapa.Yview-176),BufferFrom,Buffer[3]);
      End; {Case End}
     End;
      End; {Case Typ End}
    End;
  End;
End;