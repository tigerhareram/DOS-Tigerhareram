Procedure FundDialog;
Var EndAdding: Boolean;
Begin
  StopPlay;
  PlaySound(11);
  AddFundDiag:=True;
  EndAdding:=False;
  Repeat
    Wait(50);
    WriteAutomatScreen;
{Esc}   If Key[1]=True then EndAdding:=True;

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do Wait(1);
          If AddFundSelect>4 then Dec(AddFundSelect,5);
        End;

{Right} If Key[77]=True then
        Begin
          While Key[77]=True do Wait(1);
          If AddFundSelect<5 then Inc(AddFundSelect,5);
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do Wait(1);
          If AddFundSelect>0 then Dec(AddFundSelect);
        End;

{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do Wait(1);
          If AddFundSelect<9 then Inc(AddFundSelect);
        End;

{Enter} If Key[28]=True then
        Begin
          Case AddFundSelect of
            0: Begin
                 If Hotovost1>=5 then Begin
                                       Dec(Hotovost1,5);
                                       Inc(Credit,5);
                                       PlaySound(0);
                                       EndAdding:=True;
                                     End
                                else Begin
                                       StopPlay;
                                       PlaySound(1);
                                       Wait(500);
                                     End;
               End;
            1: Begin
                 If Hotovost1>=10 then Begin
                                        Dec(Hotovost1,10);
                                        Inc(Credit,10);
                                        StopPlay;
                                        PlaySound(0);
                                        EndAdding:=True;
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(1);
                                        Wait(500);
                                      End;
               End;
            2: Begin
                 If Hotovost1>=20 then Begin
                                        Dec(Hotovost1,20);
                                        Inc(Credit,20);
                                        StopPlay;
                                        PlaySound(0);
                                        EndAdding:=True;
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(1);
                                        Wait(500);
                                      End;
               End;
            3: Begin
                 If Hotovost1>=50 then Begin
                                        Dec(Hotovost1,50);
                                        Inc(Credit,50);
                                        StopPlay;
                                        PlaySound(0);
                                        EndAdding:=True;
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(1);
                                        Wait(500);
                                      End;
               End;
            4: Begin
                 If Hotovost1>=100 then Begin
                                         Dec(Hotovost1,100);
                                         Inc(Credit,100);
                                         StopPlay;
                                         PlaySound(0);
                                         EndAdding:=True;
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(1);
                                         Wait(500);
                                       End;
               End;
            5: Begin
                 If Hotovost1>=200 then Begin
                                         Dec(Hotovost1,200);
                                         Inc(Credit,200);
                                         StopPlay;
                                         PlaySound(0);
                                         EndAdding:=True;
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(1);
                                         Wait(500);
                                       End;
               End;
            6: Begin
                 If Hotovost1>=500 then Begin
                                         Dec(Hotovost1,500);
                                         Inc(Credit,500);
                                         StopPlay;
                                         PlaySound(0);
                                         EndAdding:=True;
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(1);
                                         Wait(500);
                                       End;
               End;
            7: Begin
                 If Hotovost1>=1000 then Begin
                                          Dec(Hotovost1,1000);
                                          Inc(Credit,1000);
                                          StopPlay;
                                          PlaySound(0);
                                          EndAdding:=True;
                                        End
                                   else Begin
                                          StopPlay;
                                          PlaySound(1);
                                          Wait(500);
                                        End;
               End;
            8: Begin
                 If Hotovost1>=2000 then Begin
                                          Dec(Hotovost1,2000);
                                          Inc(Credit,2000);
                                          StopPlay;
                                          PlaySound(0);
                                          EndAdding:=True;
                                        End
                                   else Begin
                                          StopPlay;
                                          PlaySound(1);
                                          Wait(500);
                                        End;
               End;
            9: Begin
                 If Hotovost1>=5000 then Begin
                                          Dec(Hotovost1,5000);
                                          Inc(Credit,5000);
                                          StopPlay;
                                          PlaySound(0);
                                          EndAdding:=True;
                                        End
                                   else Begin
                                          StopPlay;
                                          PlaySound(1);
                                          Wait(500);
                                        End;
               End;
          End; {Case End}
        End;
  Until EndAdding=True;
  AddFundDiag:=False;
End;