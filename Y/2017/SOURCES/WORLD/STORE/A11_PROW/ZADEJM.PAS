Procedure ZadaniJmena(Y,Pripocet:Byte);
Var Text:String[60];
    I,N: Byte;
    Ending: Boolean;
    znak: char;
    znakW: Word;
    FileName: String;
Begin
  FileName:='KNIHOVNA\index.dat';
  FindFirst(FileName , Archive, DirInfo);
  If DosError = 0 then Begin {jiz existuje}
                         Assign(F,FileName);
                         Reset(F,SizeOf(KnihovnaInfo));
                         BlockRead(F,KnihovnaInfo,1);
                         Close(F);
                       End
                  else Begin {je treba vytvorit}
                         Assign(F,FileName);
                         ReWrite(F,SizeOf(KnihovnaInfo));
                         BlockWrite(F,KnihovnaInfo,1);
                         Close(F);
                       End;
    Case Y of
      0: Text:=KnihovnaInfo.JmenaSesitu[0];
      1: Text:=KnihovnaInfo.JmenaSesitu[1];
      2: Text:=KnihovnaInfo.JmenaSesitu[2];
      3: Text:=KnihovnaInfo.JmenaSesitu[3];
      4: Text:=KnihovnaInfo.JmenaSesitu[4];
      5: Text:=KnihovnaInfo.JmenaSesitu[5];
      6: Text:=KnihovnaInfo.JmenaSesitu[6];
      7: Text:=KnihovnaInfo.JmenaSesitu[7];
      8: Text:=KnihovnaInfo.JmenaSesitu[8];
      9: Text:=KnihovnaInfo.JmenaSesitu[9];
     10: Text:=KnihovnaInfo.JmenaBloku[0];
     11: Text:=KnihovnaInfo.JmenaBloku[1];
     12: Text:=KnihovnaInfo.JmenaBloku[2];
     13: Text:=KnihovnaInfo.JmenaBloku[3];
     14: Text:=KnihovnaInfo.JmenaBloku[4];
     15: Text:=KnihovnaInfo.JmenaKnih[0];
     16: Text:=KnihovnaInfo.JmenaKnih[1];
     17: Text:=KnihovnaInfo.JmenaKnih[2];
     18: Text:=KnihovnaInfo.JmenaKnih[3];
     19: Text:=KnihovnaInfo.JmenaKnih[4];
    End; {Case End}

  Kbd_Done; {pozastavit lite keyboard}
  InitKlav; {Mircosoftova klaveska}

  If KlavesyInstalovany then
  Begin
    asm cli end;
    nastavrozlozeni(2); {czech layout} {xxx ceske je druhe}
    asm sti end;

    I:=Length(Text);

    Ending:=False;
    Repeat

      MainWorldScreen;
      SVGA_TogglePaging; {kreslit napsany radek zadavaneho jmena}
      SVGA_BarZ(20+175*1,30+15*Y+Pripocet,20+175*1+8+300,30+15*Y+Pripocet+9,ColX[0]);
      If I>0 then
      Begin
        For N:=0 to I-1 do Text_OutText(20+175*1+(N)*7,30+15*Y+Pripocet,Text[N+1],Buffer[0],SVGA);
        SVGA_BarZ(20+175*1+(N+1)*7,30+15*Y+Pripocet,20+175*1+(N+1)*7+6,30+15*Y+Pripocet+9,ColX[15]);
      End else SVGA_BarZ(20+175*1,30+15*Y+Pripocet,20+175*1+6,30+15*Y+Pripocet+9,ColX[15]);
      SVGA_TogglePaging; {kreslit napsany radek zadavaneho jmena end}

      Repeat Until Keypressed;
      if keypressed then znakW:=xReadKey {jestli neco bylo stisknuto, vyhodnotime to}
                    else znakw:=0; {jinak si sem dame nulu, aby bylo jasne, ze neni co vyhodnocovat}

      case znakw of 32..255: begin {od mezery do konce ASCII tabulky - napsatelny znak}
                               If I<50 then Begin
                                              znak:=chr(byte(znakw));
                                              Text:=Text+znak;
                                              Inc(I);
                                            End;
                             end;

                    xbksp: begin
                             If I>0 then Begin
                                           Delete(Text,I,1);
                                           Dec(I);
                                         End;
                           end;

                    xenter: begin
                              Ending:=True;
                            end;

                    xesc: begin
                            Ending:=True;
                          end;
      end; {case end}
      kResetuj;
    Until Ending=True;

    Case Y of
      0: KnihovnaInfo.JmenaSesitu[0]:=Text;
      1: KnihovnaInfo.JmenaSesitu[1]:=Text;
      2: KnihovnaInfo.JmenaSesitu[2]:=Text;
      3: KnihovnaInfo.JmenaSesitu[3]:=Text;
      4: KnihovnaInfo.JmenaSesitu[4]:=Text;
      5: KnihovnaInfo.JmenaSesitu[5]:=Text;
      6: KnihovnaInfo.JmenaSesitu[6]:=Text;
      7: KnihovnaInfo.JmenaSesitu[7]:=Text;
      8: KnihovnaInfo.JmenaSesitu[8]:=Text;
      9: KnihovnaInfo.JmenaSesitu[9]:=Text;
     10: KnihovnaInfo.JmenaBloku[0]:=Text;
     11: KnihovnaInfo.JmenaBloku[1]:=Text;
     12: KnihovnaInfo.JmenaBloku[2]:=Text;
     13: KnihovnaInfo.JmenaBloku[3]:=Text;
     14: KnihovnaInfo.JmenaBloku[4]:=Text;
     15: KnihovnaInfo.JmenaKnih[0]:=Text;
     16: KnihovnaInfo.JmenaKnih[1]:=Text;
     17: KnihovnaInfo.JmenaKnih[2]:=Text;
     18: KnihovnaInfo.JmenaKnih[3]:=Text;
     19: KnihovnaInfo.JmenaKnih[4]:=Text;
    End; {Case End}

    {ulozeni jmen knih a sesitu}
    Assign(F,FileName);
    ReWrite(F,SizeOf(KnihovnaInfo));
    BlockWrite(F,KnihovnaInfo,1);
    Close(F);
  End;

  ZrusKlav;
  Kbd_Init; {pokracovat lite keyboard}
End;

