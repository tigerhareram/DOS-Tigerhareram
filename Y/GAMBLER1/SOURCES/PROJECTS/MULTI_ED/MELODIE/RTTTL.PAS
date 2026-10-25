Procedure ZapsatRTTTL;
Var
  Ch: Char;
  Code: Integer;
  DefTrvani: Byte;
  DefOktava: Byte;
  MelodyPos: Word;
  nota: Byte;
  trvani: Byte;
  oktava: Byte;
Begin
  MelodyPos:=2;
  Repeat Read(FText,Ch); Until Ch=':';
  Repeat Read(FText,Ch); Until Ch='d';
  Read(FText,Ch); {=}
  Read(FText,Ch); {default trvani}
  Val(Ch,DefTrvani,Code);
  Repeat Read(FText,Ch); Until Ch='o';
  Read(FText,Ch); {=}
  Read(FText,Ch); {default oktava}
  Val(Ch,DefOktava,Code);
  Repeat Read(FText,Ch); Until Ch=':';
  Read(FText,Ch);
Repeat
  If ((Ch='c') or (Ch='d') or (Ch='e') or (Ch='f') or
      (Ch='g') or (Ch='a') or (Ch='b') or (Ch='p')) then
  Begin {je delka noty 2x}
    trvani:=DefTrvani;
    oktava:=DefOktava;
    Case Ch of
      'c' : nota:=0;
      'd' : nota:=2;
      'e' : nota:=4;
      'f' : nota:=5;
      'g' : nota:=7;
      'a' : nota:=9;
      'b' : nota:=11;
      'p' : nota:=120;
    End; {Case End}
    If EoF(FText)=True then Break;
    Read(FText,Ch);
    If Ch='#' then
    Begin
      Inc(nota);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    Case trvani of
      1: trvani:=64;
      2: trvani:=32;
      4: trvani:=16;
      8: trvani:=8;
     16: trvani:=4;
     32: trvani:=2;
     64: trvani:=1;
    End;
    If Ch='.' then
    Begin
      trvani:=trvani+(trvani div 2);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    If ((Ch='1') or (Ch='2') or (Ch='3') or (Ch='4') or (Ch='5') or
        (Ch='6') or (Ch='7') or (Ch='8') or (Ch='9')) then
    Begin
      Val(Ch,oktava,code);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    If nota<>120 then nota:=oktava*12+nota;
    Inc(trvani,128);
    If Ch=',' then
    Begin
      Mem[Melody.DataSeg:KanalVolba*2250+MelodyPos]:=nota;
      Mem[Melody.DataSeg:KanalVolba*2250+MelodyPos+1]:=trvani-1;
      If MelodyPos<2249 then Inc(MelodyPos,2);
      Read(FText,Ch);
    End;
  End else
  Begin {je delka noty cislo}
    oktava:=DefOktava;
    If ((Ch='1') or (Ch='2') or (Ch='4') or
        (Ch='8') or (Ch='3') or (Ch='6')) then
    Begin
      Case Ch of
        '1': Begin
               trvani:=1;
               Read(FText,Ch);
               If Ch='6' then Begin
                                trvani:=16;
                                Read(FText,Ch);
                              End;
             End;
        '2': Begin
               trvani:=2;
               Read(FText,Ch);
             End;
        '4': Begin
               trvani:=4;
               Read(FText,Ch);
             End;
        '8': Begin
               trvani:=8;
               Read(FText,Ch);
             End;
        '3': Begin
               trvani:=32;
               Read(FText,Ch);
               Read(FText,Ch);
             End;
        '6': Begin
               trvani:=64;
               Read(FText,Ch);
               Read(FText,Ch);
             End;
      End; {Case End}
    End;
    Case trvani of
      1: trvani:=64;
      2: trvani:=32;
      4: trvani:=16;
      8: trvani:=8;
     16: trvani:=4;
     32: trvani:=2;
     64: trvani:=1;
    End;
    Case Ch of
      'c' : nota:=0;
      'd' : nota:=2;
      'e' : nota:=4;
      'f' : nota:=5;
      'g' : nota:=7;
      'a' : nota:=9;
      'b' : nota:=11;
      'p' : nota:=120;
    End; {Case End}
    If EoF(FText)=True then Break;
    Read(FText,Ch);
    If Ch='#' then
    Begin
      Inc(nota);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    If Ch='.' then
    Begin
      trvani:=trvani+(trvani div 2);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    If ((Ch='1') or (Ch='2') or (Ch='3') or (Ch='4') or (Ch='5') or
        (Ch='6') or (Ch='7') or (Ch='8') or (Ch='9')) then
    Begin
      Val(Ch,oktava,code);
      If EoF(FText)=True then Break;
      Read(FText,Ch);
    End;
    If nota<>120 then nota:=oktava*12+nota;
    Inc(trvani,128);
    If Ch=',' then
    Begin
      If trvani=1 then
      Begin
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos]:=nota;
        If MelodyPos<3000 then Inc(MelodyPos);
        Read(FText,Ch);
      End else
      Begin
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos]:=nota;
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos+1]:=trvani-1;
        If MelodyPos<2999 then Inc(MelodyPos,2);
        Read(FText,Ch);
      End;
    End;
  End;
Until ((Eof(FText)=True) or (MelodyPos>=2250));
{posledni nota}
    If nota<>120 then nota:=oktava*12+nota;
    Inc(trvani,128);
    Begin
      If trvani=1 then
      Begin
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos]:=nota;
      End else
      Begin
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos]:=nota;
        Mem[Melody.DataSeg:KanalVolba*3000+MelodyPos+1]:=trvani-1;
      End;
    End;
End;