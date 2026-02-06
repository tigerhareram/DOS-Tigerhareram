Procedure HiScoreSaveLoad(Save: Boolean);
Begin
  FindFirst('trojky.dat',Archive,DirInfo);
  Case DosError Of
  0: Begin {OK -> LOAD or SAVE}
       Assign(F,'trojky.dat');
       If Save=True then Begin {SAVE}
                           ReWrite(F,1);
                           BlockWrite(F,HiScore,4);
                           BlockWrite(F,fps.prodleva,2);
                           BlockWrite(F,SB,1);
                         End
                    else Begin {LOAD}
                           Reset(F,1);
                           BlockRead(F,HiScore,4);
                           BlockRead(F,fps.prodleva,2);
                           BlockRead(F,SB,1);
                         End;
       Close(F);
     End;
 18: Begin {Not found -> Create new}
       Assign(F,'trojky.dat');
       ReWrite(F,1);
       HiScore:=DefaultHiScore;
       fps.prodleva:=50;
       SB:=False;
       BlockWrite(F,HiScore,4);
       BlockWrite(F,fps.prodleva,2);
       BlockWrite(F,SB,1);
       Close(F);
     End;
  End; {Case End}
End;