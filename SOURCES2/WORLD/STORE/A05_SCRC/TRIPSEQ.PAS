Procedure TripSeq(CasMinut: Byte);
Var Obrazec: Byte;
    CasCelkem: LongInt;
    CasJeden: LongInt;
    CasMinuty: LongInt;
    CasSekundy: LongInt;
    ZobrazCas: Boolean;
    I: Byte;

  Procedure Casomira;
  Begin
      CasSekundy:=(CasJeden-(Timer_Watch_GetTime div 1000)) mod 60;
      CasMinuty:=(CasJeden-(Timer_Watch_GetTime div 1000)) div 60;

      SVGA_BarZ(3,3,27,11,ColX[0]);
      SVGA_Rectangle(3,3,27,11,ColX[15]);

      Text_OutNumber(5,5,CasMinuty,True,Buffer[0],SVGA);
      SVGA_Pixel(15,6,ColX[15]);
      SVGA_Pixel(15,8,ColX[15]);
      Text_OutNumber(17,5,CasSekundy,True,Buffer[0],SVGA);

      If Obrazec<10 then Begin
                           SVGA_BarZ(28,3,33,11,ColX[0]);
                           SVGA_Rectangle(27,3,34,11,ColX[15]);
                           Text_OutNumber(29,5,Obrazec,True,Buffer[0],SVGA)
                         End
                    else Begin
                           SVGA_BarZ(28,3,38,11,ColX[0]);
                           SVGA_Rectangle(27,3,39,11,ColX[15]);
                           Text_OutNumber(29,5,10,True,Buffer[0],SVGA)
                         End;
  End;

Begin
  CasCelkem:=CasMinut*60;      {longint celeho casu timer handler sekund}
  CasJeden:=CasCelkem div 10;  {longint jednoho obrazce z deseti}
  ZobrazCas:=True;

  For Obrazec:=1 to 9 do
  Begin
    ShowGenerBMPSeq(Obrazec);
    SetPalette;
    Timer_Watch_Start;
    SVGA_TogglePaging;
    Repeat
      SVGA_WaitRetrace;
      If ZobrazCas=True then Casomira;
      If Key[14]=1 then Begin
                          Kbd_Rpush(14);
                          If ZobrazCas=True then ZobrazCas:=False
                                            else ZobrazCas:=True;
                          SVGA_TogglePaging;
                          ShowGenerBMPSeq(Obrazec);
                          SVGA_TogglePaging;
                        End;
    Until ((Timer_Watch_GetTime>=CasJeden*1000) or (Key[1]=1) or (Key[31]=1))=True;
    SVGA_TogglePaging;
    Timer_Watch_Stop;
    If Key[1]=1 then Kbd_RPush(1);
    If Key[31]=1 then Kbd_RPush(31);
    SetPalette;
  End;

  {Mircosoftovo}
  Obrazec:=10;
  SVGA_TogglePaging;
  SetPalette;
  pripravpaletu(pal,prvni,sirka);
  For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
  vykresliobrazec(320,240,640,480,60,prvni,sirka);
  Timer_Watch_Start;
  Repeat
    SVGA_WaitRetrace;
    If ZobrazCas=True then Casomira;
    If mircosoftSmer=0 then rotujpaletudoprava(pal,prvni,sirka)
                       else rotujpaletudoleva(pal,prvni,sirka);
    For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
    If Key[28]=1 then Begin
                        Kbd_RPush(28);
                        If mircosoftSmer=0 then mircosoftSmer:=1
                                           else mircosoftSmer:=0;
                      End;
    If Key[14]=1 then Begin
                        Kbd_Rpush(14);
                        If ZobrazCas=True then ZobrazCas:=False
                                          else ZobrazCas:=True;
                        SVGA_ClearPage(ColX[0]);
                        vykresliobrazec(320,240,640,480,60,prvni,sirka);
                      End;
  Until ((Timer_Watch_GetTime>=CasJeden*1000) or (Key[1]=1) or (Key[31]=1))=True;
  If Key[1]=1 then Kbd_RPush(1);
  If Key[31]=1 then Kbd_RPush(31);
  Timer_Watch_Stop;
  SetPalette;
  SVGA_TogglePaging;
End;