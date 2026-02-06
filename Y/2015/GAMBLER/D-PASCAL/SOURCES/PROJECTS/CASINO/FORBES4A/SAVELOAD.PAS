Procedure ResetVyhernosti;
Begin
  {Limit 65535 WORD}
   DatRec.Nahoda[0]:=14890;
   DatRec.Nahoda[1]:=49152;
   DatRec.Nahoda[2]:=21845;
   DatRec.Nahoda[3]:=20912;
   DatRec.Nahoda[4]:=49152;
   DatRec.Nahoda[5]:=21845;
   DatRec.Nahoda[6]:=27336;
   DatRec.Nahoda[7]:=49152;
   DatRec.Nahoda[8]:=21845;
   DatRec.Nahoda[9]:=32767;
End;


Procedure SaveLoadForbes(Save: Boolean);
Var I: Byte;
Begin
  FindFirst('setup.dat',Archive,DirInfo);
  Case DosError Of
  0: Begin {OK -> LOAD or SAVE}
       Assign(F,'setup.dat');
       If Save=True then Begin {SAVE}
                           ReWrite(F,1);
                           For I:=0 to 2 do DatRec.SpinValecBuff[I]:=Valec[I].SymbolCounter;
                           DatRec.StoreMultiWin:=MultiWin;
                           DatRec.StoreCredit:=Credit;
                           DatRec.StoreBet:=Bet;
                           DatRec.StoreBetMulti:=BetMulti;
                           DatRec.StoreBetCounter:=BetCounter;
                           DatRec.StoreNasobic:=Nasobic;
                           DatRec.StoreLista[0]:=Lista[0];
                           DatRec.StoreLista[1]:=Lista[1];
                           BlockWrite(F,DatRec,SizeOf(DatRec));
                         End
                    else Begin {LOAD}
                           Reset(F,1);
                           BlockRead(F,DatRec,SizeOf(DatRec));
                           MultiWin:=DatRec.StoreMultiWin;
                           Credit:=DatRec.StoreCredit;
                           BetMulti:=DatRec.StoreBetMulti;
                           Bet:=DatRec.StoreBet;
                           BetCounter:=DatRec.StoreBetCounter;
                           Nasobic:=DatRec.StoreNasobic;
                           Lista[0]:=DatRec.StoreLista[0];
                           Lista[1]:=DatRec.StoreLista[1];
                           For I:=0 to 2 do Valec[I].SymbolCounter:=DatRec.SpinValecBuff[I];
                         End;
       Close(F);
     End;
 18: Begin {Not found -> Create new}
       Assign(F,'setup.dat');
       ReWrite(F,1);
       DatRec.fpsProdleva:=15;
       DatRec.RollSpeed:=0;
       DatRec.SpinCounter:=10;
       DatRec.SpinHelper:=3; {0=85 , 1=60 , 2=35 , 3=10}
       DatRec.SBEnable:=True;
       DatRec.Svetla:=False;
       ResetVyhernosti;
       Lista[0].Enable:=True;
       Lista[0].Sazka[0]:=True;
       Lista[0].Sazka[1]:=False;
       Lista[1].Enable:=False;
       DatRec.StoreLista[0]:=Lista[0];
       DatRec.StoreLista[1]:=Lista[1];
       DatRec.NahodnyRisk:=True;
       DatRec.ModSpinu:=0;
       DatRec.SpinNumber:=0;
       DatRec.SpinNumberA:=0;
       DatRec.SpinNumberB:=0;
       DatRec.SpinNumberC:=0;
       For I:=0 to 2 do DatRec.SpinPosun[I]:=0;
       For I:=0 to 2 do DatRec.SpinPosunMark[I]:=0;
       DatRec.SpinValecBuff[0]:=Random(25); {FIRST RANDOM}
       DatRec.SpinValecBuff[0]:=Random(25);
       DatRec.SpinValecBuff[1]:=Random(25);
       DatRec.SpinValecBuff[2]:=Random(25);
       For I:=0 to 2 do Valec[I].SymbolCounter:=DatRec.SpinValecBuff[I];
       MultiWin:=0;
       Credit:=0;
       Bet:=2;
       BetMulti:=0;
       BetCounter:=0;
       Nasobic:=0;
       DatRec.StoreMultiWin:=MultiWin;
       DatRec.StoreCredit:=Credit;
       BlockWrite(F,DatRec,SizeOf(DatRec));
       Close(F);
     End;
  End; {Case End}
End;


Procedure SaveLoadPenize(Save: Boolean);
Var I: Byte;
Begin
  FindFirst('penize.sav',Archive,DirInfo);
  Case DosError Of
  0: Begin {OK -> LOAD or SAVE}
       Assign(F,'penize.sav');
       If Save=True then Begin {SAVE}
                           ReWrite(F,1);
                           DatRec2.VkladyTMP:=VkladyTMP;
                           DatRec2.VyplacenoTMP:=VyplacenoTMP;
                           BlockWrite(F,DatRec2,SizeOf(DatRec2));
                         End
                    else Begin {LOAD}
                           Reset(F,1);
                           BlockRead(F,DatRec2,SizeOf(DatRec2));
                           VkladyTMP:=DatRec2.VkladyTMP;
                           VyplacenoTMP:=DatRec2.VyplacenoTMP;
                         End;
       Close(F);
     End;
 18: Begin {Not found -> Create new}
       Assign(F,'penize.sav');
       ReWrite(F,1);
       DatRec2.VkladyTMP:=0;
       DatRec2.VyplacenoTMP:=0;
       DatRec2.Pub.Vklady:=0;
       DatRec2.Pub.Vyplaceno:=0;
       For I:=0 to MaxHistorie do Begin
                                    DatRec2.Vklad[I]:=0;
                                    DatRec2.Vyplaceno[I]:=0;
                                  End;
       DatRec2.HiScore:=0;
       DatRec2.Hotovost:=500000;
       For I:=0 to 13 do Begin
                           DatRec2.vec[I]:=True;
                           VecProdata[I]:=False;
                         End;
       DatRec2.JackPot:=0;
       DatRec2.JackPotCounter:=9;
       DatRec2.Bonus:=0;
       DatRec2.Bonus750:=0;
       BlockWrite(F,DatRec2,SizeOf(DatRec2));
       Close(F);
     End;
  End; {Case End}
End;