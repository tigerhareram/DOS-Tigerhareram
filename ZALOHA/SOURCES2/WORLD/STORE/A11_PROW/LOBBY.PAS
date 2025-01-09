Procedure SestavIPX;
Var I: Byte;
    readchar: char;
    Index: Byte;
    Count: Byte;
    Tecka: String[1];
    ReadZnak: Char;
Begin
  AdresaZadana:=True;

  if not setRecNode(AdresaServeru)
  then Begin
         For I:=1 to 30 do AdresaServeru[I]:=' ';
         For I:=0 to 5 do recNode[I]:=0;
         AdresaZadana:=False;
       End;
End;


Procedure NetworkLobby(Polozka: Byte);
Var N,I: Byte;
    ScanCode: Word;
    Ending: Boolean;
Begin
    Case Polozka of
     0: Begin {Spojit Computer}
          If ServerPripojen=True then ServerPripojen:=False;
          If AdresaZadana=True then
          Begin
            InitSend;
            N:=0;
              {test ping}
              If ClientProcess(9)=True
              then Begin
                     Inc(N); {ping ok}
                   End
              else Begin
                     ServerPripojen:=False;
                   End;
              {login process}
              If ClientProcess(1)=True
              then Begin
                     Inc(N); { dostali jsme chat slot 0 1 2 , CisloKlienta ze serveru }
                   End
              else Begin
                     ServerPripojen:=False;
                   End;
              If N=2 then ServerPripojen:=True;
          End;
        End;
     1: Begin {Zadejte IPX}
          I:=1;
          Ending:=False;
          AdresaZadana:=False;
          Repeat
            MainWorldScreen;
            SVGA_TogglePaging;
            If I>1 then
            Begin
              For N:=1 to I do Text_OutText(145+(N-1)*7,45,AdresaServeru[N],Buffer[0],SVGA);
              SVGA_BarZ(145+(I-1)*7+1,44,145+(I-1)*7+5+1,44+10,ColX[15]);
            End else SVGA_BarZ(145+(I-1)*7,44,145+(I-1)*7+5,44+10,ColX[15]);
            SVGA_TogglePaging;

            ScanCode:=Kbd_RKey;
            Kbd_RPush(ScanCode);
            If ScanCode<128 then
            Begin
              Case ScanCode of
                 2: If I<=23 then Begin
                                    AdresaServeru[I]:='1';
                                    Inc(I);
                                  End;
                 3: If I<=23 then Begin
                                    AdresaServeru[I]:='2';
                                    Inc(I);
                                  End;
                 4: If I<=23 then Begin
                                    AdresaServeru[I]:='3';
                                    Inc(I);
                                  End;
                 5: If I<=23 then Begin
                                    AdresaServeru[I]:='4';
                                    Inc(I);
                                  End;
                 6: If I<=23 then Begin
                                    AdresaServeru[I]:='5';
                                    Inc(I);
                                  End;
                 7: If I<=23 then Begin
                                    AdresaServeru[I]:='6';
                                    Inc(I);
                                  End;
                 8: If I<=23 then Begin
                                    AdresaServeru[I]:='7';
                                    Inc(I);
                                  End;
                 9: If I<=23 then Begin
                                    AdresaServeru[I]:='8';
                                    Inc(I);
                                  End;
                10: If I<=23 then Begin
                                    AdresaServeru[I]:='9';
                                    Inc(I);
                                  End;
                11: If I<=23 then Begin
                                    AdresaServeru[I]:='0';
                                    Inc(I);
                                  End;
                52: If I<=23 then Begin
                                    AdresaServeru[I]:='.';
                                    Inc(I);
                                  End;

                14: If I>1 then Begin
                                  AdresaServeru[I-1]:=' ';
                                  Dec(I);
                                End;

                28: If I<=23 then Begin
                                    AdresaServeru[I]:='.';
                                    Inc(I);

                                    SestavIPX;
                                    Ending:=True;
                                  End;
                 1: Begin
                      Ending:=True;
                    End;
              End;
            End;

          Until Ending=True;
        End;
     2: Begin
          WriterChat(85);
        End;
    End; {Case End}
End;